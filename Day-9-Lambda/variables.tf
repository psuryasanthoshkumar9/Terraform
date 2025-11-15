variable "lambda_function_name" {
  description = "Name of the Lambda function"
  type        = string
  default     = "my_lambda_function"
}

variable "lambda_handler" {
  description = "Lambda handler function"
  type        = string
  default     = "Lambda_function.lambda_handler"
}

variable "lambda_runtime" {
  description = "Runtime for Lambda"
  type        = string
  default     = "python3.11"
}

variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"  # Change this if needed
}
