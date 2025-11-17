# terraform {
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "~> 5.0"
#     }
#   }
# }

# provider "aws" {
#   region = "us-east-1"
# }

# -----------------------------
# Auto key pair
# -----------------------------
resource "tls_private_key" "auto_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "auto_keypair" {
  key_name   = "auto-key"
  public_key = tls_private_key.auto_key.public_key_openssh
}

resource "local_file" "pemfile" {
  filename = "${path.module}/auto-key.pem"
  content  = tls_private_key.auto_key.private_key_pem
}

# -----------------------------
# Networking module
# -----------------------------
module "networking" {
  source             = "./modules/networking"
  name_prefix        = var.name_prefix
  vpc_cidr           = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
}

# -----------------------------
# Security module
# -----------------------------
module "security" {
  source      = "./modules/security"
  name_prefix = var.name_prefix
  vpc_id      = module.networking.vpc_id
}

# -----------------------------
# EC2 module
# -----------------------------
module "ec2" {
  source          = "./modules/ec2"
  name_prefix     = var.name_prefix
  ami_id          = var.ami_id
  instance_type   = var.instance_type
  subnet_id       = module.networking.public_subnet_id
  security_grp_id = module.security.web_sg_id
  key_name        = aws_key_pair.auto_keypair.key_name
}
