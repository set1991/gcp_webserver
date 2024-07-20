
# Output vars VPC and subnetwork to module webserver

output "network" {
  description = "VPC network"
  value = google_compute_network.network.id
}

output "subnetwork" {
  description = "Subnetwork to webserver nginx"
  value = google_compute_subnetwork.subnetwork.id
}