resource "aws_iam_user" "deployment" {
  name = "${var.project_name}-api-deployment-${var.env}"
}

resource "aws_iam_access_key" "deployment" {
  user = aws_iam_user_policy.deployment.user
}

data "aws_iam_policy_document" "deployment" {
  statement {
    actions   = ["ecs:UpdateService"]
    resources = [aws_ecs_service.this.id]
  }
}

resource "aws_iam_user_policy" "deployment" {
  user   = aws_iam_user.deployment.name
  policy = data.aws_iam_policy_document.deployment.json
}
