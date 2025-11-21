terraform {
  required_version = ">= 1.5"
}

provider "aws" {
  region = "us-east-1"
}

# Networking module
module "networking" {
  source = "./modules/networking"
}

# IAM module
module "iam" {
  source = "./modules/iam"
}

# EC2 module
module "ec2" {
  source      = "./modules/ec2"
  subnet_id   = module.networking.public_subnet_id
  security_grp = module.networking.web_sg_id
}

# RDS module
module "rds" {
  source        = "./modules/rds"
  subnet_ids    = module.networking.private_subnet_ids
  security_grp  = module.networking.web_sg_id
}

# Lambda module
module "lambda" {
  source               = "./modules/lambda"
  lambda_function_name = "my-lambda"
  lambda_handler       = "lambda_function.lambda_handler"
  lambda_runtime       = "python3.9"
  role_arn             = module.iam.role_arn
}
