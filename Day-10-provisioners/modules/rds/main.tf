resource "aws_db_subnet_group" "default" {
  name       = "tf-db-subnet"
  subnet_ids = var.subnet_ids
}

resource "aws_db_instance" "mysql" {
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t2.micro"
  name                 = "tfdb"
  username             = "admin"
  password             = "Admin12345"
  db_subnet_group_name = aws_db_subnet_group.default.name
  skip_final_snapshot  = true
}
