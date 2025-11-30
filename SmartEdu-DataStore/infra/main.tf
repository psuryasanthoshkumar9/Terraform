terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

# -----------------------------
#  VPC (with DNS support)
# -----------------------------
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = { Name = "${var.project_name}-vpc" }
}

# -----------------------------
# Public Subnet
# -----------------------------
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
  tags                    = { Name = "${var.project_name}-public-subnet" }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "${var.project_name}-igw" }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = { Name = "${var.project_name}-public-rt" }
}

resource "aws_route_table_association" "pub_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# -----------------------------
# Private Subnets for RDS
# -----------------------------
resource "aws_subnet" "private1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = false
  availability_zone       = "us-east-1a"
  tags                    = { Name = "${var.project_name}-private-subnet-1" }
}

resource "aws_subnet" "private2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.3.0/24"
  map_public_ip_on_launch = false
  availability_zone       = "us-east-1b"
  tags                    = { Name = "${var.project_name}-private-subnet-2" }
}

# -----------------------------
# Security Group
# -----------------------------
resource "aws_security_group" "sg" {
  name        = "${var.project_name}-sg"
  description = "Allow web and app traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8084
    to_port     = 8084
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

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
}

# -----------------------------
# AUTOMATIC KEY PAIR GENERATION
# -----------------------------
resource "tls_private_key" "ci_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ci_key" {
  key_name   = "${var.project_name}-key"
  public_key = tls_private_key.ci_key.public_key_openssh
}

resource "local_file" "private_key" {
  content         = tls_private_key.ci_key.private_key_pem
  filename        = "${path.module}/${var.project_name}-key.pem"
  file_permission = "0400"
}

# -----------------------------
# EC2 Instance (CI/CD + Docker)
# -----------------------------
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "ci" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.sg.id]
  key_name               = aws_key_pair.ci_key.key_name
  user_data              = file("${path.module}/user_data.sh")

  root_block_device {
    volume_size = 50
    volume_type = "gp3"
  }

  tags = { Name = "${var.project_name}-ci" }
}

# -----------------------------
# RDS SUBNET GROUP
# -----------------------------
resource "aws_db_subnet_group" "dbsubnet" {
  name       = "${lower(var.project_name)}-db-subnet"
  subnet_ids = [aws_subnet.private1.id, aws_subnet.private2.id]

  tags = {
    Name = "${var.project_name}-db-subnet"
  }
}

# -----------------------------
# RDS MySQL
# -----------------------------
resource "aws_db_instance" "mysql" {
  identifier             = "${lower(var.project_name)}-db"
  allocated_storage      = 20
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  db_name                = "datastore"
  username               = var.db_username
  password               = var.db_password
  publicly_accessible    = true
  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.dbsubnet.name
  vpc_security_group_ids = [aws_security_group.sg.id]

  tags = { Name = "${var.project_name}-db" }
}

# -----------------------------
# Outputs
# -----------------------------
output "ci_public_ip" {
  value = aws_instance.ci.public_ip
}

output "rds_endpoint" {
  value = aws_db_instance.mysql.address
}
