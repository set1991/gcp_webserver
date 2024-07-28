#  Output ip address to nginx webserver

output "ip_webserver" {
  value =  google_compute_instance.webserver.network_interface.0.access_config.0.nat_ip
}

output "ip_prometheus" {
  value =  google_compute_instance.prometheus.network_interface.0.access_config.0.nat_ip
}
output "ip_grafana" {
  value =  google_compute_instance.grafana.network_interface.0.access_config.0.nat_ip
}

