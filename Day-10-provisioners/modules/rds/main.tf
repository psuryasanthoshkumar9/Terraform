########################
# modules/rds/main.tf
########################

resource "aws_db_subnet_group" "db_subnet" {
  name       = "day10-db-subnet-group"
  subnet_ids = [var.private_subnet_id_1, var.private_subnet_id_2]
}


resource "aws_db_instance" "mysql" {
  allocated_storage      = 20
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  db_name                = "day10db"
  username               = var.db_username
  password               = var.db_password
  parameter_group_name   = "default.mysql8.0"
  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.db_subnet.id
  vpc_security_group_ids = [var.db_sg_id]
}
