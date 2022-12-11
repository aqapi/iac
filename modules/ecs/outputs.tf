output "ecs_cluster_name" {
  value = aws_ecs_cluster.this.name
}

output "container_instance_security_group_id" {
  value = aws_security_group.container_instance.id
}

output "ec2_instance_public_dns" {
  value = aws_eip.this.public_dns
}