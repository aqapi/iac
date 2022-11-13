resource "aws_lightsail_database" "this" {
  relational_database_name = "${var.project_name}-lightsail-db-${var.env}"
  availability_zone        = var.availability_zone

  master_database_name = var.project_name
  master_username      = "admin"
  master_password      = var.db_password
  publicly_accessible  = false

  blueprint_id = "mysql_8_0"
  bundle_id    = "micro_2_0"

  skip_final_snapshot = true
  # final_snapshot_name  = "${var.project_name}-db-final-snapshot-${var.env}"

  apply_immediately = true
}
