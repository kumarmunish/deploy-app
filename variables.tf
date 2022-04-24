variable "aws_region" {
  description = "Name of default AWS region to use"
  type        = string
  default     = "ap-southeast-2"
}

variable "db_username" {
  description = "Database administrator username"
  type        = string
  default     = "potsgres"
}

variable "dbport" {
  description = "Port which the database should run on"
  default     = 5432
}

variable "db_name" {
  description = "name of the database"
  default     = "testapp"
}