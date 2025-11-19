terraform {
  required_version = ">= 1.3.0"
  required_providers {
    aws = { source = "hashicorp/aws" }
  }
}

provider "aws" {
  region = var.region
}

module "vpc" {
  source             = "../../modules/vpc"
  region             = var.region
  environment        = var.environment
  vpc_cidr           = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
}

module "sg" {
  source      = "../../modules/sg"
  environment = var.environment
  vpc_id      = module.vpc.vpc_id
}

module "ec2" {
  source        = "../../modules/ec2"
  environment   = var.environment
  instance_type = var.instance_type
  subnet_id     = module.vpc.public_subnet_id
  sg_id         = module.sg.sg_id
}

module "rds" {
  source      = "../../modules/rds"
  environment = var.environment
  subnet_id   = module.vpc.public_subnet_id
  sg_id       = module.sg.sg_id
  password    = var.rds_password
}
