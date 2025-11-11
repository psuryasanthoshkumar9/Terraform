variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "project_prefix" {
  description = "Prefix for resource names"
  default     = "pingala"
}

variable "lambda_function_name" {
  description = "Lambda function name"
  default     = "pingala-lambda-s3"
}

# how often EventBridge triggers (cron or rate)
variable "eventbridge_schedule_expression" {
  description = "EventBridge schedule expression (rate or cron)"
  default     = "rate(5 minutes)"
}

# Lambda runtime & handler
variable "lambda_runtime" {
  default = "python3.9"
}

variable "lambda_handler" {
  default = "lambda_function.lambda_handler"
}
