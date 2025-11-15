#-----------------------
# VPC with DNS enabled
#-----------------------
resource "aws_vpc" "my_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "my_vpc"
  }
}

#-----------------------
# Internet Gateway
#-----------------------
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "my_igw"
  }
}

#-----------------------
# Public Route Table
#-----------------------
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public_rt"
  }
}

#-----------------------
# Subnet 1 (AZ a)
#-----------------------
resource "aws_subnet" "my_subnet1" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "my_subnet1"
  }
}

# Associate Subnet1 with Route Table
resource "aws_route_table_association" "rta1" {
  subnet_id      = aws_subnet.my_subnet1.id
  route_table_id = aws_route_table.public_rt.id
}

#-----------------------
# Subnet 2 (AZ b)
#-----------------------
resource "aws_subnet" "my_subnet2" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "my_subnet2"
  }
}

# Associate Subnet2 with Route Table
resource "aws_route_table_association" "rta2" {
  subnet_id      = aws_subnet.my_subnet2.id
  route_table_id = aws_route_table.public_rt.id
}

#-----------------------
# Security Group
#-----------------------
resource "aws_security_group" "rds_sg" {
  name        = "rds_sg"
  description = "Allow MySQL access"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Open for testing only
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds_sg"
  }
}

#-----------------------
# DB Subnet Group
#-----------------------
resource "aws_db_subnet_group" "my_db_subnet_group" {
  name        = "my-db-subnet-group"
  subnet_ids  = [aws_subnet.my_subnet1.id, aws_subnet.my_subnet2.id]
  description = "Subnet group for RDS"
}

#-----------------------
# RDS Instance (Free-tier MySQL)
#-----------------------
resource "aws_db_instance" "my_rds" {
  identifier             = "my-free-tier-db"
  allocated_storage      = 20
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  db_name                = "mydatabase"
  username               = "admin"
  password               = "Admin12345"
  skip_final_snapshot    = true
  publicly_accessible    = true
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.my_db_subnet_group.name
  storage_type           = "gp2"
  multi_az               = false

  tags = {
    Name = "MyFreeTierRDS"
  }
}
