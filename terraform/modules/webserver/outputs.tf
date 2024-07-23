#  Output ip address to nginx webserver

output "ip_webserver" {
  value =  google_compute_instance.webserver.network_interface.0.access_config.0.nat_ip
}


