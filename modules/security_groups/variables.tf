variable "vpc_id" {}
variable "name" {}

variable "private_subnet_cidrs" {
  type = list(string)
}

variable "admin_ip" {
  description = "관리자 PC 공인 IP"
}
