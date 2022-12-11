resource "aws_security_group" "container_instance" {
  name   = "${var.project_name}-api-ec2-container-instance-${var.env}"
  vpc_id = var.vpc_id

  ingress {
    description = "Public Access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  dynamic "ingress" {
    for_each = var.ssh_allowed_list
    content {
      description = "SSH - ${ingress.value.name}"
      cidr_blocks = [ingress.value.cidr_block]
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
    }
  }

  egress {
    description = "Needed Internet Connection"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "this" {
  key_name   = "${var.project_name}-api-ec2-${var.env}"
  public_key = var.ec2_public_key
}

resource "aws_instance" "this" {
  ami           = "ami-0fab44817c875e415"
  instance_type = var.ec2_instance_type
  key_name      = aws_key_pair.this.key_name

  credit_specification {
    cpu_credits = "standard"
  }

  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.container_instance.id]

  iam_instance_profile = aws_iam_instance_profile.container_instance.name

  user_data = base64encode(<<EOF
#!/bin/bash
echo ECS_CLUSTER=${local.ecs_cluster_name} >> /etc/ecs/ecs.config
EOF
  )

  tags = {
    Name = "${var.project_name}-api-ec2-${var.env}"
  }
}

resource "aws_eip" "this" {
  instance = aws_instance.this.id
}
