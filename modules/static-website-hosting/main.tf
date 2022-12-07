locals {
  s3_origin_id = "${var.project_name}-${var.env}"
}

resource "aws_s3_bucket" "this" {
  bucket = "${var.project_name}-static-website-hosting-${var.env}"
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.bucket

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.allow_get_object_oai.json
}

data "aws_iam_policy_document" "allow_get_object_oai" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["${aws_cloudfront_origin_access_identity.this.iam_arn}"]
    }

    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.this.arn}/*"]
  }
}

resource "aws_cloudfront_origin_access_identity" "this" {
  comment = "${var.project_name} host oai for ${var.env}"
}

data "aws_cloudfront_cache_policy" "default" {
  name = "Managed-CachingOptimized"
}

resource "aws_cloudfront_distribution" "this" {
  enabled             = true
  comment             = "${var.project_name} ${var.env}"
  price_class         = "PriceClass_100"
  default_root_object = "index.html"
  aliases             = ["${var.alternate_domain_name}"]

  custom_error_response {
    error_code            = 403
    response_code         = 200
    response_page_path    = "/index.html"
    error_caching_min_ttl = 10
  }

  custom_error_response {
    error_code            = 404
    response_code         = 200
    response_page_path    = "/index.html"
    error_caching_min_ttl = 10
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    compress               = true
    target_origin_id       = local.s3_origin_id
    viewer_protocol_policy = "redirect-to-https"

    cache_policy_id = data.aws_cloudfront_cache_policy.default.id
  }

  origin {
    origin_id   = local.s3_origin_id
    domain_name = aws_s3_bucket.this.bucket_domain_name

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.this.cloudfront_access_identity_path
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

resource "aws_iam_user" "deployment" {
  name = "${var.project_name}-website-deployment-${var.env}"
}

resource "aws_iam_access_key" "deployment" {
  user = aws_iam_user_policy.deployment.user
}

data "aws_iam_policy_document" "deployment" {
  statement {
    actions   = ["s3:ListBucket"]
    resources = ["${aws_s3_bucket.this.arn}"]
  }

  statement {
    actions = [
      "s3:GetObject",
      "s3:DeleteObject",
      "s3:PutObject"
    ]
    resources = ["${aws_s3_bucket.this.arn}/*"]
  }

  statement {
    actions   = ["cloudfront:CreateInvalidation"]
    resources = [aws_cloudfront_distribution.this.arn]
  }
}

resource "aws_iam_user_policy" "deployment" {
  user   = aws_iam_user.deployment.name
  policy = data.aws_iam_policy_document.deployment.json
}
