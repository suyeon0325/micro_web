region = "ap-northeast-2"
name = "alice-staging"
vpc_cidr = "10.0.0.0/16"

public_subnet_cidr_a = "10.0.1.0/24"
public_subnet_cidr_c = "10.0.2.0/24"
private_subnet_cidr_a = "10.0.3.0/24"
private_subnet_cidr_c = "10.0.4.0/24"

az_a = "ap-northeast-2a"
az_c = "ap-northeast-2c"

nat_instance_type = "t3.micro"
bastion_instance_type = "t2.micro"
admin_ip = "0.0.0.0/0" #테스트 상태 /실제 관리 PC의 공인 IP 사용해야함"