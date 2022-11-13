terraform {
  cloud {
    organization = "aqapi"

    workspaces {
      name = "aqapi-main"
    }
  }

  required_providers {
    aws = {
      version = ">= 4.37.0"
      source  = "hashicorp/aws"
    }
  }
}

provider "aws" {
  profile = "kopan"
  region  = "eu-central-1"

  default_tags {
    tags = {
      Terraform   = "true"
      Maintainer  = "kopunk"
      Project     = local.project
      Environment = local.env
    }
  }
}

provider "aws" {
  alias = "us_east_1"

  profile = "kopan"
  region  = "us-east-1"

  default_tags {
    tags = {
      Terraform   = "true"
      Maintainer  = "kopunk"
      Project     = local.project
      Environment = local.env
    }
  }
}
