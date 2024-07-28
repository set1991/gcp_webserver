variable "gcp_srv_key" {
  description = "JSON key-file from gcp"
  default = "/home/set/keys/new-mygcp-cred.json"
}

variable "gcp_project" {
  description = "Project id from GSP"
  default = "prod-429618"
}

variable "gcp_region" {
  description = "Region"
  default = "europe-west2"
}
variable "gcp_zone" {
  description = "Zone "
  default =  "europe-west2-a"
}

variable "name" {
  description = "name for project"
  default = "nginx-webserver"
}

variable "ip_subnetwork" {
  description = "range ip adresses for subnet"
  default = "10.0.100.0/24"
}
variable "state_bucket" {
  description = "bucket gcp for the state_file"
  default = "bucket-tfstate-aliferenko91"
  
}
variable "tags_firewall" {
  description = "tags firewall rules to compute instance"
  type = map(string)
  default = {
    http = "http-server"
    ssh = "ssh-server" 
    grafana = "grafana"
    prometheus = "prometheus"
  }
}
variable "ssh_user" {
  description = "SSH user for ansible"
  default = "sasha_aliferenko91"
}
variable "ssh_pub_key" {
  description = "Pub key for adnsible"
  default = "/home/set/keys/terraform_ed25519.pub"
}
variable "ssh_private_key" {
  description = "private key for ansible"
  default = "/home/set/keys/terraform_ed25519"
}
