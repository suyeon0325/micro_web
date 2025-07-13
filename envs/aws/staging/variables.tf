variable "region" {}
variable "name" {}
variable "vpc_cidr" {}

variable "public_subnet_cidr_a" {}
variable "public_subnet_cidr_c" {}
variable "private_subnet_cidr_a" {}
variable "private_subnet_cidr_c" {}

variable "az_a" {}
variable "az_c" {}

variable "nat_instance_type" {}
variable "bastion_instance_type" {}
variable "admin_ip" {}