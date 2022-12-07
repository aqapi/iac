output "s3_arn" {
  value = aws_s3_bucket.this.arn
}

output "cloudfront_arn" {
  value = aws_cloudfront_distribution.this.arn
}

output "website_deployment_user_key_id" {
  value = aws_iam_access_key.deployment.id
}

output "website_deployment_user_secret_access_key" {
  value     = aws_iam_access_key.deployment.secret
  sensitive = true
}
