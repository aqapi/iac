locals {
  ecs_cluster_name = "${var.project_name}-${var.env}"
}

resource "aws_ecs_cluster" "this" {
  name = local.ecs_cluster_name
}
