output "instance_id" {
  value = aws_instance.alice.id
}

output "network_interface_id" {
  value = aws_instance.alice.primary_network_interface_id
}
