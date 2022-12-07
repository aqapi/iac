resource "aws_security_group" "this" {
  name   = "${var.project_name}-db-${var.env}"
  vpc_id = var.vpc_id
}

resource "aws_security_group_rule" "ingress" {
  security_group_id = aws_security_group.this.id

  type      = "ingress"
  from_port = 3306
  to_port   = 3306
  protocol  = "tcp"

  source_security_group_id = var.access_security_group
}

resource "aws_security_group_rule" "egress" {
  security_group_id = aws_security_group.this.id

  type      = "egress"
  from_port = 3306
  to_port   = 3306
  protocol  = "tcp"

  source_security_group_id = var.access_security_group
}

resource "aws_db_instance" "this" {
  identifier = "${var.project_name}-${var.env}"

  multi_az               = false
  db_subnet_group_name   = var.db_subnet_group_name
  vpc_security_group_ids = [aws_security_group.this.id]

  engine              = "mysql"
  engine_version      = "8.0"
  skip_final_snapshot = true
  allocated_storage   = 5
  instance_class      = "db.t4g.micro"

  db_name  = var.project_name
  username = "admin"
  password = var.master_db_password
}
