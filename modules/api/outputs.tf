output "container_instance_security_group_id" {
  value = aws_security_group.container_instance.id
}

output "api_deployment_user_key_id" {
  value = aws_iam_access_key.deployment.id
}

output "api_deployment_user_secret_access_key" {
  value     = aws_iam_access_key.deployment.secret
  sensitive = true
}
