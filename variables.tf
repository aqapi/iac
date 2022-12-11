variable "master_database_password" {
  type      = string
  sensitive = true
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

variable "ec2_container_instance_access" {
  description = "List of objects containing source name and ip, eg. [{name = \"Office\", cidr_block = \"123.123.123.123/32\"}]"

  type = list(object({
    name       = string
    cidr_block = string
  }))
}
