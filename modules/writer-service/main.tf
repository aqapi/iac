data "aws_ecs_cluster" "this" {
  cluster_name = var.ecs_cluster_name
}

resource "aws_ecs_task_definition" "this" {
  family                   = "${var.project_name}-writer-service-ec2-${var.env}"
  requires_compatibilities = ["EC2"]
  network_mode             = "bridge"
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn
  task_role_arn            = aws_iam_role.ecs_task.arn

  container_definitions = jsonencode([
    {
      name      = "${var.project_name}-writer-service-${var.env}"
      image     = var.image
      memory    = var.container_memory
      essential = true

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

resource "aws_cloudwatch_event_rule" "this" {
  name                = "${var.project_name}-writer-service-schedule-${var.env}"
  schedule_expression = var.schedule
}

resource "aws_cloudwatch_event_target" "this" {
  arn      = data.aws_ecs_cluster.this.arn
  rule     = aws_cloudwatch_event_rule.this.name
  role_arn = aws_iam_role.event.arn

  ecs_target {
    task_count          = 1
    task_definition_arn = aws_ecs_task_definition.this.arn
  }
}
