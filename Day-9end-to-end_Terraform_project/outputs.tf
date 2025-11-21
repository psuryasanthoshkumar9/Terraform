output "ec2_public_ip" {
  value       = aws_instance.web.public_ip
  description = "Public IP of the EC2 web server"
}

output "ssh_private_key_file" {
  value       = local_file.private_key_pem.filename
  description = "Local path to the generated private key PEM"
}

output "lambda_function_name" {
  value = aws_lambda_function.from_s3.function_name
}

output "lambda_arn" {
  value = aws_lambda_function.from_s3.arn
}

output "lambda_s3_bucket" {
  value = aws_s3_bucket.lambda_bucket.bucket
}

output "kms_key_arn" {
  value = aws_kms_key.cmk.arn
}
