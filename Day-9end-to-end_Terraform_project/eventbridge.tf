resource "aws_cloudwatch_event_rule" "schedule_rule" {
  name                = "${var.project_prefix}-schedule-${random_string.suffix.result}"
  schedule_expression = var.eventbridge_schedule_expression
  description         = "Periodic trigger for Lambda"
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.schedule_rule.name
  target_id = "invoke-lambda"
  arn       = aws_lambda_function.from_s3.arn
}

# Grant permission for EventBridge to invoke the Lambda
resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge-${random_string.suffix.result}"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.from_s3.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.schedule_rule.arn
}
