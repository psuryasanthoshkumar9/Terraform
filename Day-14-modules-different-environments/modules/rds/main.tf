resource "random_password" "rds_password" {
  length           = 16
  special          = true
  override_special = "!@#%^&*()_+"
}

resource "aws_db_subnet_group" "this" {
  name       = "${var.project_name}-${var.environment}-db-subnet"
  subnet_ids = var.subnets_ids
  tags = {
    Name = "${var.project_name}-${var.environment}-db-subnet"
  }
}

resource "aws_db_instance" "this" {
  allocated_storage      = 20
  engine                 = "mysql"
  engine_version         = "8.0"          # keep 8.0
  instance_class         = var.instance_class   # pass db.t3.micro
  db_name                = var.db_name
  username               = var.db_username
  password               = random_password.rds_password.result
  publicly_accessible    = true
  skip_final_snapshot    = true
  vpc_security_group_ids = var.security_group_ids
  db_subnet_group_name   = aws_db_subnet_group.this.name
}

output "rds_endpoint" {
  value = aws_db_instance.this.endpoint
}

output "rds_password" {
  value     = random_password.rds_password.result
  sensitive = true
}
