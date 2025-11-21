# provider "aws" {
#   region = "us-east-1"   # Change as per your region
# }

# IAM role for Lambda
resource "aws_iam_role" "lambda_exec_role" {
  name = "${var.lambda_function_name}-exec-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# Attach policy for logging
resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Lambda function
resource "aws_lambda_function" "my_lambda" {
  function_name = var.lambda_function_name
  handler       = var.lambda_handler
  runtime       = var.lambda_runtime
  role          = aws_iam_role.lambda_exec_role.arn

  filename         = "Lambda_function.zip"    # Use exact spelling
  source_code_hash = filebase64sha256("Lambda_function.zip")

  memory_size = 128
  timeout     = 10

  tags = {
    Name = var.lambda_function_name
  }
}

# Optional: Output Lambda ARN
output "lambda_arn" {
  value       = aws_lambda_function.my_lambda.arn
  description = "The ARN of the Lambda function"
}
