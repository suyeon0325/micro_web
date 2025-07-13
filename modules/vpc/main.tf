resource "aws_vpc" "alice" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = var.name
  }
}
