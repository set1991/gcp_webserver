
#CREATE compute instance for nginx
resource "google_compute_instance" "webserver" {
  name = "${var.name}"
  machine_type = "e2-medium"
  project = var.gcp_project
  zone = var.gcp_zone    
  # We're tagging the instance with the tag specified in the firewall rule from NETWORK MODULE
  tags = [var.tags_firewall["http"], var.tags_firewall["ssh"], var.tags_firewall["prometheus"]]
  boot_disk {
    initialize_params {
      image = "ubuntu-2204-jammy-v20240614"
    }
  }  
  metadata_startup_script = <<-EOT
  wget https://github.com/prometheus/node_exporter/releases/download/v1.8.1/node_exporter-1.8.1.linux-amd64.tar.gz
  tar -xvf node_exporter-1.8.1.linux-amd64.tar.gz
  sudo cp node_exporter-1.8.1.linux-amd64/node_exporter /usr/local/bin/
  sudo useradd -rs /bin/false nodeusr
  sudo chown nodeusr:nodeusr /usr/local/bin/node_exporter
  sudo bash -c 'cat << EOF > /etc/systemd/system/node_exporter.service
  [Unit]
  Description=Node Exporter
  Wants=network-online.target
  After=network-online.target

  [Service]
  User=nodeusr
  Group=nodeusr
  Type=simple
  ExecStart=/usr/local/bin/node_exporter

  [Install]
  WantedBy=multi-user.target
  EOF'

  #start node_exporter service
  sudo systemctl daemon-reload
  sudo systemctl start node_exporter
  sudo systemctl enable node_exporter
  sudo systemctl status node_exporter
    
  EOT
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








  


