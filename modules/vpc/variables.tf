variable "name" {
  description = "Name of the environment"
}

variable "tags" {
  default = {}
  type    = "map"
}

variable "cidr_block" {}

variable "ip_to_ssh_from" {}

variable "ssh_public_key" {}
