variable "environment" {}
variable "subnet_id" {}
variable "sg_id" {}
variable "password" {}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "${var.environment}-db-subnet-group"
  subnet_ids = [var.subnet_id]
  tags = { Name = "${var.environment}-db-subnet-group" }
}

resource "aws_db_instance" "mysql" {
  identifier              = "${var.environment}-rds"
  allocated_storage       = 20
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t3.micro"
  name                    = "appdb"
  username                = "admin"
  password                = var.password
  skip_final_snapshot     = true
  publicly_accessible     = true
  vpc_security_group_ids  = [var.sg_id]
  db_subnet_group_name    = aws_db_subnet_group.db_subnet_group.name
  tags = { Name = "${var.environment}-rds" }
}
