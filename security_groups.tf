# Creating security group for the application load balancer

resource "aws_security_group" "load_balancer_security_group" {
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "service_security_group" {
  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    # Only allowing traffic in from the load balancer security group
    security_groups = ["${aws_security_group.load_balancer_security_group.id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "database" {
  name   = "database"
  vpc_id = aws_default_vpc.default_vpc.id
}

resource "aws_security_group_rule" "allow_db_access" {
  type              = "ingress"
  from_port         = var.dbport
  to_port           = var.dbport
  protocol          = "tcp"
  security_group_id = aws_security_group.database.id
  cidr_blocks       = ["${aws_default_subnet.default_subnet_1.cidr_block}", "${aws_default_subnet.default_subnet_2.cidr_block}", "${aws_default_subnet.default_subnet_3.cidr_block}"]
}