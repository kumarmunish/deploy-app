resource "aws_db_instance" "appdb" {
  identifier             = "appdb"
  instance_class         = "db.t3.micro"
  allocated_storage      = 5
  engine                 = "postgres"
  engine_version         = "12.10"
  port                   = var.dbport
  name                   = "app"
  username               = var.db_username
  password               = aws_ssm_parameter.db_password.value
  db_subnet_group_name   = aws_db_subnet_group.database.id
  vpc_security_group_ids = [aws_security_group.database.id]
  publicly_accessible    = false
  skip_final_snapshot    = true
}
