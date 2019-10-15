provider "aws" {
  region = "${var.region}"
}

# Deploy Compute Resources
module "compute_sources" {
  source = "./compute"
  availability_zone = "${var.region}"
  pubkey = "${var.pubkey}"
  vpc_security_group_id = "${module.security_groups.k8s_security_grp_id}"
  vpc_subnet_id = "${module.networking.vpc_subnet_id}"
  loadbalancer_name = "${var.loadbalancer_name}"
  vpc_cidr = "${var.vpc_cidr}"
  k8s_route_table_id = "${module.networking.route_table_id}"

}

module "networking" {
  source = "./networking"
  vpc_cidr = "${var.vpc_cidr}"
  subnet_cidr = "${var.subnet_cidr}"
}

module "security_groups" {
  source = "./secgroups"
  vpc_id = "${module.networking.vpc_id}"
  security_grp_name = "${var.k8s-security_grp_name}"
}
