output "lambda_arn" {
  value       = aws_lambda_function.my_lambda.arn
  description = "The ARN of the Lambda function"
}

output "eventbridge_rule_arn" {
  value       = aws_cloudwatch_event_rule.event_rule.arn
  description = "The ARN of the EventBridge rule"
}
