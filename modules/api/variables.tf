variable "project_name" {
  type = string
}

variable "env" {
  type = string
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
  description = "container image repository url"
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

variable "container_memory" {
  type        = number
  description = "MiB of memory for the container"
}

variable "ecs_cluster_name" {
  type = string
}

variable "ec2_instance_public_dns" {
  type = string
}
