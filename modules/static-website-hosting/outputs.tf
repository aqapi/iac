output "s3_arn" {
  value = aws_s3_bucket.this.arn
}

output "cloudfront_arn" {
  value = aws_cloudfront_distribution.this.arn
}
