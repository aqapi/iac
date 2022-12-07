output "security_group_id" {
  value = aws_security_group.this.id
}

output "db_url" {
  value = aws_db_instance.this.address
}
