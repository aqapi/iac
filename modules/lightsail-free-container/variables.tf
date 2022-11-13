variable "project_name" {
  type = string
}

variable "env" {
  type = string
}

variable "container_image" {
  type = string
}

variable "ssl_certificate_arn" {
  type = string
}

variable "alternate_domain_name" {
  type = string
}

variable "db_host" {
  type = string
}

variable "db_user" {
  type = string
}

variable "db_secret" {
  type      = string
  sensitive = true
}

variable "allowed_locations" {
  type = list(string)
}
