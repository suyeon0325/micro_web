variable "vpc_id" {}
variable "igw_id" {}
variable "nat_network_interface_ids" {
  type = list(string)
}
variable "public_subnet_ids" {
  type = list(string)
}
variable "private_subnet_ids" {
  type = list(string)
}