resource "aws_iam_instance_profile" "container_instance" {
  name = "${var.project_name}-ec2-container-instance-${var.env}"
  role = aws_iam_role.container_instance.name
}

resource "aws_iam_role" "container_instance" {
  name                = "${var.project_name}-ec2-container-instance-${var.env}"
  managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"]
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      },
    ]
  })
}