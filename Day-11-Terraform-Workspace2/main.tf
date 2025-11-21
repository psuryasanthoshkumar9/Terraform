terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source = "hashicorp/random"
    }
  }
}

provider "aws" {
  region = var.region
}

# ---------------------------------------------------
# RANDOM SUFFIX (Avoid Duplicate Names in IAM / EC2)
# ---------------------------------------------------
resource "random_id" "suffix" {
  byte_length = 2
}

# ---------------------------------------------------
# IAM USER
# ---------------------------------------------------
resource "aws_iam_user" "surya_user" {
  name          = "SuryaUser-${terraform.workspace}-${random_id.suffix.hex}"
  force_destroy = true
}

# ---------------------------------------------------
# IAM POLICY DOCUMENT
# ---------------------------------------------------
data "aws_iam_policy_document" "admin_doc" {
  statement {
    actions   = ["*"]
    resources = ["*"]
  }
}

# ---------------------------------------------------
# IAM POLICY
# ---------------------------------------------------
resource "aws_iam_policy" "admin_policy" {
  name        = "AdminPolicy-${terraform.workspace}-${random_id.suffix.hex}"
  description = "Full admin policy"
  policy      = data.aws_iam_policy_document.admin_doc.json
}

# ---------------------------------------------------
# POLICY ATTACHMENT
# ---------------------------------------------------
resource "aws_iam_user_policy_attachment" "attach_policy" {
  user       = aws_iam_user.surya_user.name
  policy_arn = aws_iam_policy.admin_policy.arn
}

# ---------------------------------------------------
# IAM ACCESS KEY (Taintable)
# ---------------------------------------------------
resource "aws_iam_access_key" "surya_key" {
  user = aws_iam_user.surya_user.name
}

# ---------------------------------------------------
# SECURITY GROUP for EC2
# ---------------------------------------------------
resource "aws_security_group" "ec2_sg" {
  name        = "EC2-SG-${terraform.workspace}-${random_id.suffix.hex}"
  description = "Allow SSH and HTTP traffic"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
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

# ---------------------------------------------------
# DEFAULT VPC FOR EC2
# ---------------------------------------------------
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# ---------------------------------------------------
# EC2 INSTANCE
# ---------------------------------------------------
resource "aws_instance" "web" {
  ami           = var.ami
  instance_type = "t2.micro"
  subnet_id     = data.aws_subnets.default_subnets.ids[0]
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  tags = {
    Name = "WebServer-${terraform.workspace}-${random_id.suffix.hex}"
  }
}
