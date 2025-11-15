terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.19"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

# provider "aws" {
#   region = "us-east-1"
# }

# safe lowercase+numeric suffix for names
resource "random_string" "suffix" {
  length  = 6
  lower   = true
  upper   = false
  numeric = true
  special = false
}

# RDS password: printable, no forbidden symbols for AWS (no space, /, @, " )
resource "random_password" "rds_password" {
  length  = 16
  lower   = true
  upper   = true
  numeric = true
  special = false
}

# VPC + subnets + IGW + route table + associations
resource "aws_vpc" "this" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = { Name = "tf-vpc" }
}

resource "aws_subnet" "a" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = { Name = "tf-subnet-a" }
}

resource "aws_subnet" "b" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
  tags = { Name = "tf-subnet-b" }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id
  tags   = { Name = "tf-igw" }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = { Name = "tf-public-rt" }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.b.id
  route_table_id = aws_route_table.public.id
}

# security group for RDS (allow MySQL)
resource "aws_security_group" "rds" {
  name        = "rds-sg"
  description = "Allow MySQL"
  vpc_id      = aws_vpc.this.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "rds-sg" }
}

# DB Subnet Group (name uses only lowercase+digits+hyphen allowed pattern)
resource "aws_db_subnet_group" "dbsub" {
  name       = "mydbsubnetgroup-${random_string.suffix.result}"
  subnet_ids = [aws_subnet.a.id, aws_subnet.b.id]
  tags       = { Name = "tf-db-subnet-group" }
}

# Secrets Manager (store username+password as JSON)
resource "aws_secretsmanager_secret" "rds_secret" {
  name = "rds-db-secret-${random_string.suffix.result}"
}

resource "aws_secretsmanager_secret_version" "rds_secret_version" {
  secret_id     = aws_secretsmanager_secret.rds_secret.id
  secret_string = jsonencode({
    username = "admin"
    password = random_password.rds_password.result
  })
}

# Primary RDS instance — backup retention >0 so replicas can be created
resource "aws_db_instance" "primary" {
  identifier              = "my-free-tier-db-${random_string.suffix.result}"
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  storage_type            = "gp2"
  username                = "admin"
  password                = random_password.rds_password.result
  db_subnet_group_name    = aws_db_subnet_group.dbsub.name
  vpc_security_group_ids  = [aws_security_group.rds.id]
  publicly_accessible     = true
  backup_retention_period = 7     # REQUIRED for read replicas
  skip_final_snapshot     = true

  # ensure secrets & SG are created before RDS
  depends_on = [
    aws_secretsmanager_secret_version.rds_secret_version,
    aws_security_group.rds
  ]

  tags = { Name = "tf-primary-rds" }
}

# Read replica — uses ARN of the primary (no username/password here)
resource "aws_db_instance" "replica" {
  identifier             = "my-rds-replica-${random_string.suffix.result}"
  replicate_source_db    = aws_db_instance.primary.arn
  instance_class         = "db.t3.micro"
  db_subnet_group_name   = aws_db_subnet_group.dbsub.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  publicly_accessible    = true
  skip_final_snapshot    = true

  depends_on = [aws_db_instance.primary]
  tags = { Name = "tf-read-replica" }
}
