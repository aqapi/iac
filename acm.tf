resource "aws_acm_certificate" "aqapi_us_east_1_wildcard" {
  provider = aws.us_east_1

  domain_name               = "aqapi.cloud"
  subject_alternative_names = ["*.aqapi.cloud"]

  validation_method = "DNS"

  lifecycle {
    # https://developer.hashicorp.com/terraform/language/meta-arguments/lifecycle
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "aqapi_us_east_1_wildcard" {
  provider = aws.us_east_1

  certificate_arn = aws_acm_certificate.aqapi_us_east_1_wildcard.arn
}

output "aqapi_us_east_1_wildcard_dns_validation_cname_name" {
  value = aws_acm_certificate.aqapi_us_east_1_wildcard.domain_validation_options.*.resource_record_name[0]
}

output "aqapi_us_east_1_wildcard_dns_validation_cname_value" {
  value = aws_acm_certificate.aqapi_us_east_1_wildcard.domain_validation_options.*.resource_record_value[0]
}
