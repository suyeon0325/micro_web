resource "aws_instance" "alice" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  key_name                    = var.key_name
  associate_public_ip_address = true
  source_dest_check           = false
  vpc_security_group_ids      = var.security_group_ids
  
  tags = {
    Name = var.name
  }
}