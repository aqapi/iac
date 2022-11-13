output "db_url" {
  value = aws_lightsail_database.this.master_endpoint_address
}
