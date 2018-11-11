locals {
  tags = {
    project    = "Terraform Demo"
    meetupName = "TBDevOps"
  }

  east_region = "us-east-2"
  west_region = "us-west-1"

  east_cidr = "10.0.0.0/16"
  west_cidr = "10.1.0.0/16"

  ssh_cidr = "${var.my_ip}/32"
}

module "vpc-east" {
  source               = "modules/vpc"
  name                 = "atlantic"
  ip_to_ssh_from       = "${local.ssh_cidr}"
  ssh_public_key       = "${var.ssh_public_key}"
  cidr_block           = "${local.east_cidr}"
  tags                 = "${local.tags}"
  dd_api_token         = "${var.dd_api_key}"
  ssh_private_key_file = "${var.ssh_private_key_file}"

  providers {
    aws = "aws.east"
  }
}

module "vpc-west" {
  source               = "modules/vpc"
  name                 = "pacific"
  ip_to_ssh_from       = "${local.ssh_cidr}"
  ssh_public_key       = "${var.ssh_public_key}"
  cidr_block           = "${local.west_cidr}"
  tags                 = "${local.tags}"
  dd_api_token         = "${var.dd_api_key}"
  ssh_private_key_file = "${var.ssh_private_key_file}"

  providers {
    aws = "aws.west"
  }
}

// Setup peering
module "east-west-route" {
  source              = "modules/peering"
  main_region         = "${local.east_region}"
  main_vpc_id         = "${module.vpc-east.vpc_id}"
  main_route_table_id = "${module.vpc-east.route_table_id}"
  main_cidr           = "${local.east_cidr}"
  peer_region         = "${local.west_region}"
  peer_vpc_id         = "${module.vpc-west.vpc_id}"
  peer_route_table_id = "${module.vpc-west.route_table_id}"
  peer_cidr           = "${local.west_cidr}"
}

// configure datadog
module "datadog" {
  source     = "modules/datadog"
  dd_api_key = "${var.dd_api_key}"
  dd_app_key = "${var.dd_app_key}"
}
