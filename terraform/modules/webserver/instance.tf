
#CREATE compute instance for nginx
resource "google_compute_instance" "webserver" {
  name = "${var.name}"
  machine_type = "e2-small"
  project = var.gcp_project
  zone = var.gcp_zone    
  # We're tagging the instance with the tag specified in the firewall rule from NETWORK MODULE
  tags = [var.tags_firewall["http"], var.tags_firewall["ssh"]]
  boot_disk {
    initialize_params {
      image = "ubuntu-2204-jammy-v20240614"
    }
  }  
  metadata = {
    ssh-keys = "${var.ssh_user}:${file(var.ssh_pub_key)}"
  }
  network_interface{
    network = var.network
    subnetwork = var.subnetwork
    access_config {
      // Ephemeral public IP
    }
  }
}
#Create ansible configuration file
resource "local_file" "config_ansible" {
  filename = "../ansible_project/ansible.cfg"
  content = <<EOF
  [defaults]
  remote_user = ${var.ssh_user}
  private_key_file = ${var.ssh_private_key}
  inventory         =./hosts.ini
  host_key_checking = False
  EOF
}
#Create dynamic inventory ansible file
resource "local_file" "inventory_run_ansible" {
  filename = "../ansible_project/hosts.ini" 
  content = <<EOF
  [webservers]
  ${google_compute_instance.webserver.name}   ansible_host=${google_compute_instance.webserver.network_interface.0.access_config.0.nat_ip}
  EOF
  
  #wait until the ssh service starts working 
  provisioner "remote-exec" {
    inline = ["echo 'login successful on nginx webserver'"]

    connection {
      host = google_compute_instance.webserver.network_interface.0.access_config.0.nat_ip
      type = "ssh"
      user = "${var.ssh_user}"
      private_key = "${file(var.ssh_private_key)}"
    }
  }

}








  


