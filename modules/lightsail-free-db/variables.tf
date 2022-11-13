variable "project_name" {
  type = string
}

variable "env" {
  type = string
}

variable "availability_zone" {
  type = string
}

variable "db_password" {
  type      = string
  sensitive = true
}
