provider "aws" {
  region = "us-east-1"
}

# ----------------------------
# VPC Module
# ----------------------------
module "vpc" {
  source               = "./modules/vpc"
  project_name         = var.project_name
  environment          = var.environment
  vpc_cidr             = "10.0.0.0/16"
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  availability_zones   = ["us-east-1a", "us-east-1b"]
}

# ----------------------------
# Security Group for EC2
# ----------------------------
resource "aws_security_group" "ec2_sg" {
  name   = "${var.project_name}-${var.environment}-sg"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
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

# ----------------------------
# EC2 Module
# ----------------------------
module "ec2" {
  source            = "./modules/ec2"
  project_name      = var.project_name
  environment       = var.environment
  vpc_id            = module.vpc.vpc_id
  subnets_ids       = module.vpc.public_subnets_ids
  ami               = "ami-0c02fb55956c7d316"
  instance_type     = "t2.micro"
  instance_count    = 2
  security_group_ids = [aws_security_group.ec2_sg.id]   # ✅ Now works
}


# ----------------------------
# RDS Module
# ----------------------------
module "rds" {
  source             = "./modules/rds"
  project_name       = var.project_name
  environment        = var.environment
  instance_class     = var.instance_class
  db_name            = "mydb"
  db_username        = "admin"
  subnets_ids        = module.vpc.public_subnets_ids
  security_group_ids = [aws_security_group.ec2_sg.id]
}

# ----------------------------
# S3 Module
# ----------------------------
module "s3" {
  source       = "./modules/s3"
  project_name = var.project_name
  environment  = var.environment
}
