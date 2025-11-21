terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

##########################
# Variables
##########################
variable "instance_type" {
  default = "t2.micro"
}

variable "ssh_username" {
  default = "ec2-user"
}

variable "private_key_path" {
  default = "./terraform-key.pem"
}

##########################
# Generate SSH Key
##########################
resource "tls_private_key" "ec2_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "generated_key" {
  key_name   = "terraform-key"
  public_key = tls_private_key.ec2_key.public_key_openssh
}

resource "local_file" "private_key_pem" {
  content         = tls_private_key.ec2_key.private_key_pem
  filename        = var.private_key_path
  file_permission = "0400"
}

##########################
# Default VPC & Subnet
##########################
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

locals {
  public_subnet_id = data.aws_subnets.default_subnets.ids[0]
}

##########################
# Existing Internet Gateway
##########################
data "aws_internet_gateway" "default_igw" {
  filter {
    name   = "attachment.vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

##########################
# Security Group
##########################
resource "aws_security_group" "web_sg" {
  name        = "tf-web-sg"
  description = "Allow SSH + HTTP"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
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

##########################
# Amazon Linux 2 AMI
##########################
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.*-x86_64-gp2"]
  }
}

##########################
# EC2 Instance
##########################
resource "aws_instance" "web" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.generated_key.key_name
  subnet_id                   = local.public_subnet_id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.web_sg.id]

  tags = {
    Name = "Terraform-Web-Server"
  }

  # Upload index.html
  provisioner "file" {
    content     = "<h1>🚀 Terraform Nginx Fully Working!</h1>"
    destination = "/tmp/index.html"

    connection {
      type        = "ssh"
      user        = var.ssh_username
      private_key = tls_private_key.ec2_key.private_key_pem
      host        = self.public_ip
      timeout     = "5m"
    }
  }

  # Install Nginx using amazon-linux-extras
  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo amazon-linux-extras enable nginx1",
      "sudo yum install -y nginx",
      "sudo mkdir -p /usr/share/nginx/html",
      "sudo mv /tmp/index.html /usr/share/nginx/html/index.html",
      "sudo chmod 644 /usr/share/nginx/html/index.html",
      "sudo systemctl enable nginx",
      "sudo systemctl start nginx"
    ]

    connection {
      type        = "ssh"
      user        = var.ssh_username
      private_key = tls_private_key.ec2_key.private_key_pem
      host        = self.public_ip
      timeout     = "5m"
    }
  }
}

##########################
# Outputs
##########################
output "instance_public_ip" {
  value = aws_instance.web.public_ip
}

output "website_url" {
  value = "http://${aws_instance.web.public_ip}"
}

output "private_key_path" {
  value = var.private_key_path
}
