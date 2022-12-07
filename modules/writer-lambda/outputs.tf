output "lambda_deployment_user_key_id" {
  value = aws_iam_access_key.deployment.id
}

output "lambda_deployment_user_secret_access_key" {
  value     = aws_iam_access_key.deployment.secret
  sensitive = true
}
