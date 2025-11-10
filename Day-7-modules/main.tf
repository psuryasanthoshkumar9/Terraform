provider "aws" {
  region = var.aws_region
}

module "networking" {
  source   = "./modules/networking"
  vpc_cidr = var.vpc_cidr
}

module "ec2" {
  source     = "./modules/ec2"
  subnet_ids = module.networking.public_subnet_ids
  key_name   = var.key_name
}

module "rds" {
  source     = "./modules/rds"
  vpc_id     = module.networking.vpc_id
  subnet_ids = module.networking.private_subnet_ids
}

module "lambda" {
  source         = "./modules/lambda"
  s3_bucket      = var.lambda_s3_bucket
  function_name  = var.lambda_function_name
  handler        = var.lambda_handler
  runtime        = var.lambda_runtime
}

module "iam" {
  source = "./modules/iam"
}
