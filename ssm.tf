resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "aws_ssm_parameter" "db_password" {
  name        = "/rds/ghost_db_password"
  type        = "SecureString"
  value       = random_password.password.result
  description = "The password for the Ghost RDS database"
}

resource "aws_ssm_parameter" "db_username" {
  name        = "/rds/ghost_db_username"
  type        = "String"
  value       = "ghost_user"
  description = "The username for the Ghost RDS database"
}

resource "aws_ssm_parameter" "db_name" {
  name        = "/rds/ghost_db_name"
  type        = "String"
  value       = "ghost_db"
  description = "The name of the Ghost RDS database"
}
