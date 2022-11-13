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

## lightsail free tier

the project will have to be migrated to other server and database service 25.01.2023 as lightsail free tier will end around then

## resources needed in aqapi

- [ ] s3 bucket
- [ ] cloudfront distribution
- [ ] acm certificate
- [ ] lightsail container instance
- [ ] lightsail db instance
- [ ] lambda function
- [ ] container repository