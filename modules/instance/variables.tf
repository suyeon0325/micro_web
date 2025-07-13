variable "ami_id" {}
variable "name" {}
variable "instance_type" {}
variable "subnet_id" {}
variable "key_name" {}
variable "security_group_ids" {
  description = "보안 그룹 ID 리스트"
  type        = list(string)
}