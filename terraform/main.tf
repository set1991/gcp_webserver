module "network" {
    source = "./modules/network"
    gcp_project = var.gcp_project
    gcp_region = var.gcp_region
    name = var.name
    tags_firewall = var.tags_firewall
    ip_subnetwork = var.ip_subnetwork
}
module "webserver" {
    source = "./modules/webserver"
    gcp_project = var.gcp_project
    gcp_region = var.gcp_region
    gcp_zone = var.gcp_zone
    name = var.name
    tags_firewall = var.tags_firewall
    ssh_user = var.ssh_user
    ssh_pub_key = var.ssh_pub_key
    ssh_private_key = var.ssh_private_key
    network = module.network.network
    subnetwork = module.network.subnetwork
    
    depends_on = [ module.network ]
}







