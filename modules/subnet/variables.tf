variable "vpc_id" {}
variable "cidr_block" {}
variable "name" {}
variable "availability_zone" {}
variable "map_public_ip_on_launch" {
  default = false
}