provider "aws" {
  region = var.region
}

### ssh keyname - aws계정의 실제 keyname으로 설정되어야 합니다. 

data "aws_secretsmanager_secret_version" "ssh_key_name" {
  secret_id = "ssh-key-name"
}
locals {
  key_name = data.aws_secretsmanager_secret_version.ssh_key_name.secret_string
}

### NAT Instance ami 이미지 동적사용
data "aws_ami" "nat" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn-ami-vpc-nat*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

### bastion Instance ami 이미지 동적사용 (Amazon Linux 2)
data "aws_ami" "bastion" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

###
module "vpc" {
  source   = "../../../modules/vpc"
  vpc_cidr = var.vpc_cidr
  name     = var.name
}

module "igw" {
  source = "../../../modules/igw"
  vpc_id = module.vpc.vpc_id
}

module "public_subnet_a" {
  source                 = "../../../modules/subnet"
  vpc_id                 = module.vpc.vpc_id
  cidr_block             = var.public_subnet_cidr_a
  availability_zone      = var.az_a
  map_public_ip_on_launch = true
  name = "public-subnet-a"
}

module "public_subnet_c" {
  source                 = "../../../modules/subnet"
  vpc_id                 = module.vpc.vpc_id
  cidr_block             = var.public_subnet_cidr_c
  availability_zone      = var.az_c
  map_public_ip_on_launch = true
  name = "public-subnet-c"
}

module "private_subnet_a" {
  source            = "../../../modules/subnet"
  vpc_id            = module.vpc.vpc_id
  cidr_block        = var.private_subnet_cidr_a
  availability_zone = var.az_a
  name = "private-subnet-a"
}

module "private_subnet_c" {
  source            = "../../../modules/subnet"
  vpc_id            = module.vpc.vpc_id
  cidr_block        = var.private_subnet_cidr_c
  availability_zone = var.az_c
  name = "private-subnet-c"
}

module "nat_instance_a" {
  source         = "../../../modules/instance"
  subnet_id      = module.public_subnet_a.subnet_id
  ami_id         = data.aws_ami.nat.id
  instance_type  = var.nat_instance_type
  key_name       = local.key_name
  security_group_ids = [module.security_groups.public_subnet_nat_sg_id]
  name               = "nat-instance-a"
}

module "nat_instance_c" {
  source         = "../../../modules/instance"
  subnet_id      = module.public_subnet_c.subnet_id
  ami_id         = data.aws_ami.nat.id
  instance_type  = var.nat_instance_type
  key_name       = local.key_name
  security_group_ids = [module.security_groups.public_subnet_nat_sg_id]
  name               = "nat-instance-c"
}

module "bastion_instance_a" {
  source         = "../../../modules/instance"
  subnet_id      = module.public_subnet_a.subnet_id
  ami_id         = data.aws_ami.bastion.id
  instance_type  = var.bastion_instance_type
  key_name       = local.key_name
  security_group_ids = [module.security_groups.public_subnet_bastion_sg_id]
  name               = "bastion-instance-a"
}

module "bastion_instance_c" {
  source         = "../../../modules/instance"
  subnet_id      = module.public_subnet_c.subnet_id
  ami_id         = data.aws_ami.bastion.id
  instance_type  = var.bastion_instance_type
  key_name       = local.key_name
  security_group_ids = [module.security_groups.public_subnet_bastion_sg_id]
  name               = "bastion-instance-c"
}

module "routetable" {
  source = "../../../modules/routetable"

  vpc_id  = module.vpc.vpc_id
  igw_id  = module.igw.igw_id

  nat_network_interface_ids = [
    module.nat_instance_a.network_interface_id,
    module.nat_instance_c.network_interface_id
  ]

  private_subnet_ids = [
    module.private_subnet_a.subnet_id,
    module.private_subnet_c.subnet_id
  ]

  public_subnet_ids = [
    module.public_subnet_a.subnet_id,
    module.public_subnet_c.subnet_id
  ]
}

module "security_groups" {
  source = "../../../modules/security_groups"

  vpc_id = module.vpc.vpc_id
  name   = var.name

  private_subnet_cidrs = [
    var.private_subnet_cidr_a,
    var.private_subnet_cidr_c
  ]

  admin_ip = var.admin_ip
}
