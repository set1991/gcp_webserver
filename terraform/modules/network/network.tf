#CREATE A NEW VPS NETWORK 
resource "google_compute_network" "network" {
  project                 = var.gcp_project
  name                    = "${var.name}-network"
  auto_create_subnetworks = false
}
#CREATE  SUBNETWORK 
resource "google_compute_subnetwork" "subnetwork" {
  name          = "${var.name}-subnetwork"
  ip_cidr_range = var.ip_subnetwork
  region        = var.gcp_region
  network       = google_compute_network.network.id
  
}



