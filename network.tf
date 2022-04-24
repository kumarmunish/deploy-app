resource "aws_default_vpc" "default_vpc" {
}

# Use default subnets
resource "aws_default_subnet" "default_subnet_1" {
  availability_zone = "${var.aws_region}a"
}

resource "aws_default_subnet" "default_subnet_2" {
  availability_zone = "${var.aws_region}b"
}

resource "aws_default_subnet" "default_subnet_3" {
  availability_zone = "${var.aws_region}c"
}

resource "aws_db_subnet_group" "database" {
  name       = "database"
  subnet_ids = ["${aws_default_subnet.default_subnet_1.id}", "${aws_default_subnet.default_subnet_2.id}", "${aws_default_subnet.default_subnet_3.id}"]
}