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

variable "schedule" {
  type        = string
  description = "E.g. cron(0 0 ? * * 0) or rate(1 hour)"
}

variable "container_memory" {
  type        = number
  description = "MiB of memory for the container"
}

variable "ecs_cluster_name" {
  type = string
}

variable "image" {
  type        = string
  description = "container image repository url"
}
