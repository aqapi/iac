variable "project_name" {
  type = string
}

variable "env" {
  type = string
}

variable "db_subnet_group_name" {
  type = string
}

variable "master_db_password" {
  type      = string
  sensitive = true
}

variable "vpc_id" {
  type = string
}

variable "access_security_group" {
  type = string
}
