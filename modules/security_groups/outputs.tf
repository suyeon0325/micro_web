output "public_subnet_nat_sg_id" {
  value = aws_security_group.nat_sg.id
}

output "public_subnet_bastion_sg_id" {
  value = aws_security_group.bastion_sg.id
}

output "private_subnet_sg_id" {
  value = aws_security_group.private_subnet_sg.id
}
