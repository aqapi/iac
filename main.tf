locals {
  project = "aqapi"
  env     = "main"
}

module "static_website_hosting" {
  source = "./modules/static-website-hosting"

  project_name = local.project
  env          = local.env

  alternate_domain_name = "aqapi.cloud"
  ssl_certificate_arn   = aws_acm_certificate.aqapi_us_east_1_wildcard.arn
}

module "lightsail_container" {
  source = "./modules/lightsail-free-container"

  project_name = local.project
  env          = local.env

  domain_name         = "api.aqapi.cloud"
  ssl_certificate_arn = aws_acm_certificate.aqapi_us_east_1_wildcard.arn
}
