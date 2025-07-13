# bastion SG
resource "aws_security_group" "bastion_sg" {
  name        = "${var.name}-public-subnet-bastion-sg"
  description = "Allow inbound SSH from admin"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow SSH from admin PC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.admin_ip]
  }
  tags = {
    Name = "${var.name}-public-subnet-bastion-sg"
  }

    egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# NAT 인스턴스 SG
resource "aws_security_group" "nat_sg" {
  name        = "${var.name}-public-subnet-nat-sg"
  description = "inbound from private subnet"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow all TCP from private subnets"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = var.private_subnet_cidrs
  }

  ingress {
    description = "Allow SSH from admin PC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }
  tags = {
    Name = "${var.name}-public-subnet-nat-sg"
  }
    egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Private 인스턴스 SG
resource "aws_security_group" "private_subnet_sg" {
  name        = "${var.name}-private-subnet-sg"
  description = "Private Instance SG"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow SSH from Bastion SG"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-private-subnet-sg"
  }
}
