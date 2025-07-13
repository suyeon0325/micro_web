# 퍼블릭 서브넷용
resource "aws_route_table" "public" {
  vpc_id = var.vpc_id
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = var.igw_id
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_ids)
  subnet_id      = var.public_subnet_ids[count.index]
  route_table_id = aws_route_table.public.id
}

# 프라이빗 서브넷용
resource "aws_route_table" "private_a" {
  vpc_id = var.vpc_id

  route {
    cidr_block           = "0.0.0.0/0"
    network_interface_id = var.nat_network_interface_ids[0]
  }
}

resource "aws_route_table" "private_c" {
  vpc_id = var.vpc_id

  route {
    cidr_block           = "0.0.0.0/0"
    network_interface_id = var.nat_network_interface_ids[1]
  }
}

resource "aws_route_table_association" "private_a" {
  subnet_id      = var.private_subnet_ids[0]
  route_table_id = aws_route_table.private_a.id
}

resource "aws_route_table_association" "private_c" {
  subnet_id      = var.private_subnet_ids[1]
  route_table_id = aws_route_table.private_c.id
}