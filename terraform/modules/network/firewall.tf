
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

resource "google_compute_firewall" "default-allow-grafana" {
name    = "${var.name}-allow-grafana"
network = google_compute_network.network.name

  allow {
  protocol = "tcp"
  ports    = ["3000"]
   }

 source_ranges = ["0.0.0.0/0"]
 target_tags = [ var.tags_firewall["grafana"] ]
}

resource "google_compute_firewall" "default-allow-prometheus" {
name    = "${var.name}-allow-prometheus"
network = google_compute_network.network.name

  allow {
  protocol = "tcp"
  ports    = ["9090", "9100"]
   }

 source_ranges = ["0.0.0.0/0"]
 target_tags = [ var.tags_firewall["prometheus"] ]
}



