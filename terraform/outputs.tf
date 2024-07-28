# ------------------------------------------------------------------------------
# LOAD BALANCER IP ADDRESS OUTPUT
# ------------------------------------------------------------------------------
output "ip_webserver" {
  description = "IP address for nginx webserver"
  value       = module.webserver.ip_webserver
}

output "ip_grafana" {
  description = "IP address for nginx webserver"
  value       = module.webserver.ip_grafana
}
output "ip_prometheus" {
  description = "IP address for nginx webserver"
  value       = module.webserver.ip_prometheus
}




