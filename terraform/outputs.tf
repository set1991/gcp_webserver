# ------------------------------------------------------------------------------
# LOAD BALANCER IP ADDRESS OUTPUT
# ------------------------------------------------------------------------------
output "ip_webserver" {
  description = "IP address for nginx webserver"
  value       = module.webserver.ip_webserver
}




