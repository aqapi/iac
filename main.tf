locals {
  project = "aqapi"
  env     = "main"
  region  = "eu-central-1"
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

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.18.1"

  enable_dns_hostnames = true

  name = "${local.project}-${local.env}"
  cidr = "10.0.0.0/16"

  azs            = ["${local.region}a", "${local.region}b"]
  public_subnets = ["10.0.1.0/24", "10.0.2.0/24"]

  create_database_subnet_group = true
  database_subnets             = ["10.0.101.0/24", "10.0.102.0/24"]
}

module "db" {
  source = "./modules/db"

  project_name = local.project
  env          = local.env

  vpc_id                = module.vpc.vpc_id
  db_subnet_group_name  = module.vpc.database_subnet_group
  master_db_password    = var.master_database_password
  access_security_group = module.api.container_instance_security_group_id
}

module "api" {
  source = "./modules/api"

  project_name = local.project
  env          = local.env

  vpc_id               = module.vpc.vpc_id
  db_security_group_id = module.db.security_group_id
  subnet_id            = module.vpc.public_subnets[0]
  availability_zone    = "${local.region}a"

  ec2_public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIE1+U4xO3qbVmHNT8OO6iJsudgcnTTBb7NM6UTSSJeF aqapi ec2 instance"

  ssh_allowed_list = []

  db_url      = module.db.db_url
  db_user     = var.db_user
  db_secret   = var.db_secret
  db_database = var.db_database

  image = "ghcr.io/aqapi/api:latest"

  alternate_domain_name = "api.aqapi.cloud"
  ssl_certificate_arn   = aws_acm_certificate.aqapi_us_east_1_wildcard.arn

  allowed_locations = ["PL"]
}

module "writer_lambda" {
  source = "./modules/writer-lambda"

  project_name = local.project
  env          = local.env

  schedule = "rate(365 days)"
  handler  = "pl.kozubek.writerlambda.app.data.handler.MeasuringDataHandler::handleRequest"

  vpc_id    = module.vpc.vpc_id
  subnet_id = module.vpc.public_subnets[0]

  db_url      = module.db.db_url
  db_user     = var.db_user
  db_secret   = var.db_secret
  db_database = var.db_database
}
