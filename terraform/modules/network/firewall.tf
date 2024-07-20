
#CREATE FIREWALL RULE FOR NETWORK  (ALLOW HTTP, HTTPS, SSH)
resource "google_compute_firewall" "default-allow-http" {
  name    = "${var.name}-allow-http-s"
  network = google_compute_network.network.name
  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags = [ var.tags_firewall["http"] ]
}

resource "google_compute_firewall" "default-allow-ssh" {
  name    = "${var.name}-allow-ssh"
  network = google_compute_network.network.name
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags = [ var.tags_firewall["ssh"] ]
}



