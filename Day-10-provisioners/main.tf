########################
# root: main.tf
########################

module "networking" {
  source = "./modules/networking"

  vpc_cidr            = "10.0.0.0/16"
  public_subnet_cidr  = "10.0.1.0/24"
  private_subnet_cidr = "10.0.2.0/24"
}

module "ec2" {
  source = "./modules/ec2"

  subnet_id       = module.networking.public_subnet_id
  security_grp_id = module.networking.web_sg_id
  key_name        = var.key_name
}

module "rds" {
  source = "./modules/rds"

  vpc_id              = module.networking.vpc_id
  private_subnet_id_1 = module.networking.private_subnet_id_1
  private_subnet_id_2 = module.networking.private_subnet_id_2
  db_sg_id            = module.networking.db_sg_id

  db_username = var.db_username
  db_password = var.db_password
}




module "lambda" {
  source = "./modules/lambda"

  s3_bucket    = var.app_bucket
  s3_key       = "lambda_function_payload.zip" # ensure you upload artifact
  handler      = "index.handler"
  runtime      = "nodejs18.x"
  lambda_sg_id = module.networking.web_sg_id
}
