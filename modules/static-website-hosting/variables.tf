variable "project_name" {
  type = string
}

variable "env" {
  type = string
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
