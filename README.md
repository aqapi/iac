# aqapi infrastructure as code repository

## getting started

1. set up Terraform Cloud either by using `terraform login` or `.terraformrc` file

   - `.terraformrc`:
     - `touch .terraformrc`
     - configure `credentials` block in the file:
       ```
       credentials "app.terraform.io" {
         token = "<api token>"
       }
       ```
   - `export TF_CLI_CONFIG_FILE=$(pwd)/.terraformrc`

2. run `terraform init`

## main used resources

- api server:
  - VPC network
  - EC2 instance
  - ECS Cluster
    - 1 Service
    - 1 Task
    - 1 Scheduled Task
  - RDS instance
  - Cloudfront Distribution
  - CloudWatch Event Rule and Event Target
- webapp:
  - S3 bucket
  - Cloudfront Distribution

## deployment users

api, writer service and website have deployment users defined in order to deploy and apply changes to the resources from CI

more information on the CI processes can be found in the other repositories

## infrastructure costs

this project can be deployed 100% within the AWS Free Tier, the only cost associated with it is the domain (aqapi.cloud) - $1.51
