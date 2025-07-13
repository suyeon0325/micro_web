output "vpc_id" {
  value = module.vpc.vpc_id
}

output "nat_instance_a_id" {
  value = module.nat_instance_a.instance_id
}

output "nat_instance_c_id" {
  value = module.nat_instance_c.instance_id
}
