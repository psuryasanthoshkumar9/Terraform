########################
# root: outputs.tf
########################

output "vpc_id" {
  value = module.networking.vpc_id
}

output "ec2_public_ip" {
  value = module.ec2.public_ip
}

output "rds_endpoint" {
  value = module.rds.endpoint
}

output "lambda_arn" {
  value = module.lambda.lambda_arn
}

########################
# modules/networking/variables.tf
########################

# variables for networking module
variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  type    = string
  default = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  type    = string
  default = "10.0.2.0/24"
}