locals {
  project = "aqapi"
  env     = "main"
}

data "aws_region" "this" {}

module "static_website_hosting" {
  source = "./modules/static-website-hosting"

  project_name = local.project
  env          = local.env

  alternate_domain_name = "aqapi.cloud"
  ssl_certificate_arn   = aws_acm_certificate.aqapi_us_east_1_wildcard.arn

  allowed_locations = ["PL"]
}

module "lightsail_container" {
  source = "./modules/lightsail-free-container"

  project_name = local.project
  env          = local.env

  container_image = "amazon/amazon-lightsail:hello-world"

  db_host   = ""
  db_user   = ""
  db_secret = ""

  alternate_domain_name = "api.aqapi.cloud"
  ssl_certificate_arn   = aws_acm_certificate.aqapi_us_east_1_wildcard.arn

  allowed_locations = ["PL"]
}

module "lightsail_db" {
  source = "./modules/lightsail-free-db"

  project_name      = local.project
  env               = local.env
  availability_zone = "${data.aws_region.this.name}a"

  db_password = var.master_database_password
}
