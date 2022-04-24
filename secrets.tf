resource "random_password" "password" {
  length           = 20
  special          = false
  override_special = "/_%@ "
}


resource "aws_ssm_parameter" "db_password" {
  name        = "/test/database/password"
  description = "Test app database password"
  type        = "SecureString"
  value       = random_password.password.result
}