output "public_subnet_ids" {
  value = module.networking.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.networking.private_subnet_ids
}

output "ec2_instance_id" {
  value = module.ec2.instance_id
}

output "lambda_arn" {
  value = module.lambda.lambda_arn
}

output "rds_endpoint" {
  value = module.rds.rds_endpoint
}
