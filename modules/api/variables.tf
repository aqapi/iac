variable "project_name" {
  type = string
}

variable "env" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "db_security_group_id" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "availability_zone" {
  type = string
}

variable "ec2_public_key" {
  type = string
}

variable "ssh_allowed_list" {
  description = "List of objects containing source name and ip, eg. [{name = \"Office\", cidr_block = \"123.123.123.123/32\"}]"

  type = list(object({
    name       = string
    cidr_block = string
  }))
}

variable "db_url" {
  type = string
}

variable "db_user" {
  type = string
}

variable "db_secret" {
  type      = string
  sensitive = true
}

variable "db_database" {
  type = string
}

variable "image" {
  type        = string
  description = "container image reository urli"
}

variable "ssl_certificate_arn" {
  type = string
}

variable "alternate_domain_name" {
  type = string
}

variable "allowed_locations" {
  type = list(string)
}
