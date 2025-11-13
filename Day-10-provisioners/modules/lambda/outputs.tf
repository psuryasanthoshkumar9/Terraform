########################
# modules/lambda/outputs.tf
########################

output "lambda_arn" {
  value = aws_lambda_function.app.arn
}