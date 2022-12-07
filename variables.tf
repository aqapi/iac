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
