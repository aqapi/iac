resource "aws_lightsail_container_service" "this" {
  name  = "${var.project_name}-${var.env}"
  power = "micro"
  scale = 1
}

resource "aws_lightsail_container_service_deployment_version" "this" {
  service_name = aws_lightsail_container_service.this.name

  container {
    container_name = "hello-world"
    image          = "amazon/amazon-lightsail:hello-world"

    # command = []

    # environment = {
    #   MY_ENVIRONMENT_VARIABLE = "my_value"
    # }

    ports = {
      80 = "HTTP"
    }
  }

  public_endpoint {
    container_name = "hello-world"
    container_port = 80

    health_check {
      healthy_threshold   = 2
      unhealthy_threshold = 2
      timeout_seconds     = 2
      interval_seconds    = 5
      path                = "/"
      success_codes       = "200-499"
    }
  }

}

data "aws_cloudfront_cache_policy" "default" {
  name = "Managed-CachingOptimized"
}

resource "aws_cloudfront_distribution" "this" {
  enabled     = true
  comment     = "${var.project_name} api ${var.env}"
  price_class = "PriceClass_100"
  aliases     = ["${var.domain_name}"]

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    compress               = true
    target_origin_id       = var.domain_name
    viewer_protocol_policy = "redirect-to-https"

    cache_policy_id = data.aws_cloudfront_cache_policy.default.id
  }

  origin {
    origin_id   = var.domain_name
    domain_name = trimsuffix(trimprefix(aws_lightsail_container_service.this.url, "https://"), "/")

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["PL"]
    }
  }

  viewer_certificate {
    acm_certificate_arn      = var.ssl_certificate_arn
    minimum_protocol_version = "TLSv1.2_2021"
    ssl_support_method       = "sni-only"
  }
}
