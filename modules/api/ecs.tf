locals {
  container_name          = "${var.project_name}-api-container-${var.env}"
  cluster_name            = "${var.project_name}-api-cluster-${var.env}"
  container_external_port = 80
}

resource "aws_ecs_cluster" "this" {
  name = local.cluster_name
}

resource "aws_ecs_task_definition" "this" {
  family                   = "${var.project_name}-api-ec2-${var.env}"
  requires_compatibilities = ["EC2"]
  network_mode             = "bridge"
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn
  task_role_arn            = aws_iam_role.ecs_task.arn

  container_definitions = jsonencode([
    {
      name      = local.container_name
      image     = var.image
      memory    = floor(data.aws_ec2_instance_type.container_instance.memory_size * 0.9) # use 90% of instance's memory
      essential = true

      portMappings = [
        {
          containerPort = 8080
          hostPort      = local.container_external_port
        }
      ]

      environment = [
        {
          name  = "DB_DATABASE"
          value = var.db_database
        },
        {
          name  = "DB_USER"
          value = var.db_user
        },
        {
          name  = "DB_HOST"
          value = var.db_url
        },
        {
          name  = "DB_SECRET"
          value = var.db_secret
        }
      ]
    },
  ])
}

resource "aws_ecs_service" "this" {
  name                 = "${var.project_name}-api-${var.env}"
  cluster              = aws_ecs_cluster.this.id
  task_definition      = aws_ecs_task_definition.this.arn
  force_new_deployment = true

  desired_count                      = 1
  deployment_minimum_healthy_percent = 0

  depends_on = [aws_iam_role.ecs_task_execution]
}
