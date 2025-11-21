resource "aws_db_subnet_group" "default" {
  name       = "my-db-subnet-group"
  subnet_ids = var.subnet_ids
}

resource "aws_db_instance" "default" {
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t2.micro"
  name                 = "mydb"
  username             = "admin"
  password             = "password123!"
  db_subnet_group_name = aws_db_subnet_group.default.id
  vpc_security_group_ids = [var.security_grp]
  skip_final_snapshot  = true
}
