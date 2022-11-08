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

## resources needed in aqapi

- [ ] s3 bucket
- [ ] cloudfront distribution
- [ ] acm certificate
- [ ] lightsail container instance
- [ ] lightsail db instance
- [ ] lambda function
- [ ] container repository