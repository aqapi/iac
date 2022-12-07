resource "aws_cloudwatch_event_rule" "this" {
  name                = "${var.project_name}-writer-lambda-schedule-${var.env}"
  schedule_expression = var.schedule
}

resource "aws_cloudwatch_event_target" "this" {
  rule      = aws_cloudwatch_event_rule.this.name
  arn       = aws_lambda_function.this.arn
  target_id = aws_lambda_function.this.function_name
}

resource "aws_lambda_permission" "this" {
  function_name = aws_lambda_function.this.function_name
  action        = "lambda:InvokeFunction"
  principal     = "events.amazonaws.com"
  statement_id  = "AllowExecutionFromCloudWatch"
}

resource "aws_iam_user" "deployment" {
  name = "${var.project_name}-writer-lambda-deployment-${var.env}"
}

resource "aws_iam_access_key" "deployment" {
  user = aws_iam_user_policy.deployment.user
}

data "aws_iam_policy_document" "deployment" {
  statement {
    actions   = ["lambda:UpdateFunctionCode"]
    resources = [aws_lambda_function.this.arn]
  }
}

resource "aws_iam_user_policy" "deployment" {
  user   = aws_iam_user.deployment.name
  policy = data.aws_iam_policy_document.deployment.json
}

data "aws_iam_policy" "this" {
  name = "AWSLambdaVPCAccessExecutionRole"
}

resource "aws_iam_role" "this" {
  name                = "${var.project_name}-writer-lambda-role-${var.env}"
  managed_policy_arns = [data.aws_iam_policy.this.arn]

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Effect = "Allow"
      }
    ]
  })
}

resource "aws_security_group" "this" {
  name   = "${var.project_name}-writer-lambda-${var.env}"
  vpc_id = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "archive_file" "workaround" {
  type        = "zip"
  output_path = "${path.module}/dummy-deployment.zip"

  source {
    content  = "text"
    filename = "dummy.txt"
  }
}

resource "aws_lambda_function" "this" {
  function_name = "${var.project_name}-writer-lambda-${var.env}"
  role          = aws_iam_role.this.arn

  handler = var.handler

  runtime       = "java11"
  architectures = ["x86_64"]
  memory_size   = 128
  timeout       = 5

  package_type = "Zip"

  vpc_config {
    subnet_ids         = [var.subnet_id]
    security_group_ids = [aws_security_group.this.id]
  }

  environment {
    variables = {
      DB_URL      = var.db_url,
      DB_USER     = var.db_user,
      DB_SECRET   = var.db_secret,
      DB_DATABASE = var.db_database,
    }
  }

  # workaround to external zip deployment
  filename = data.archive_file.workaround.output_path
  lifecycle {
    ignore_changes = [filename]
  }
}
