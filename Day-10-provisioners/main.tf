provider "aws" {
  region = var.aws_region
}

########################
# Networking Module
########################
module "networking" {
  source = "./modules/networking"
}

########################
# IAM Module
########################
module "iam" {
  source = "./modules/iam"
}

########################
# EC2 Module
########################
module "ec2" {
  source       = "./modules/ec2"
  subnet_id    = module.networking.public_subnet_id
  security_grp = module.networking.web_sg_id
  key_name     = module.ec2.key_name
}

########################
# RDS Module
########################
module "rds" {
  source     = "./modules/rds"
  subnet_ids = module.networking.private_subnet_ids
}

########################
# Lambda Module
########################
module "lambda" {
  source    = "./modules/lambda"
  role_arn  = module.iam.lambda_role_arn
  s3_bucket = "pingala"
  s3_key    = "Lambda_function.zip"
}
