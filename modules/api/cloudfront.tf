data "aws_cloudfront_cache_policy" "default" {
  name = "Managed-CachingOptimized"
}

resource "aws_cloudfront_distribution" "this" {
  enabled     = true
  comment     = "${var.project_name} api ${var.env}"
  price_class = "PriceClass_100"
  aliases     = ["${var.alternate_domain_name}"]

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    compress               = true
    target_origin_id       = var.alternate_domain_name
    viewer_protocol_policy = "redirect-to-https"

    cache_policy_id = data.aws_cloudfront_cache_policy.default.id
  }

  origin {
    origin_id   = var.alternate_domain_name
    domain_name = var.ec2_instance_public_dns

    custom_origin_config {
      http_port              = 80
      https_port             = 80
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = var.allowed_locations
    }
  }

  viewer_certificate {
    acm_certificate_arn      = var.ssl_certificate_arn
    minimum_protocol_version = "TLSv1.2_2021"
    ssl_support_method       = "sni-only"
  }
}
