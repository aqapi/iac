data "aws_ecs_cluster" "this" {
  cluster_name = var.ecs_cluster_name
}

resource "aws_ecs_task_definition" "this" {
  family                   = "${var.project_name}-api-ec2-${var.env}"
  requires_compatibilities = ["EC2"]
  network_mode             = "bridge"
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn
  task_role_arn            = aws_iam_role.ecs_task.arn

  container_definitions = jsonencode([
    {
      name      = "${var.project_name}-api-${var.env}"
      image     = var.image
      memory    = var.container_memory
      essential = true

      portMappings = [
        {
          containerPort = 8080
          hostPort      = 80
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
  cluster              = data.aws_ecs_cluster.this.arn
  task_definition      = aws_ecs_task_definition.this.arn
  force_new_deployment = true

  desired_count                      = 1
  deployment_minimum_healthy_percent = 0

  depends_on = [aws_iam_role.ecs_task_execution]
}
