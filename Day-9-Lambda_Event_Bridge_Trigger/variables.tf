variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "lambda_function_name" {
  description = "Name of the Lambda function"
  default     = "terraform_eventbridge_lambda"
}

variable "lambda_handler" {
  description = "Lambda handler"
  default     = "lambda_function.lambda_handler"
}

variable "lambda_runtime" {
  description = "Lambda runtime"
  default     = "python3.9"
}

variable "eventbridge_rule_name" {
  description = "Name of the EventBridge rule"
  default     = "terraform-lambda-eventbridge-rule"
}

variable "eventbridge_schedule_expression" {
  description = "Schedule expression for EventBridge rule"
  default     = "rate(5 minutes)" # every 5 minutes
}
