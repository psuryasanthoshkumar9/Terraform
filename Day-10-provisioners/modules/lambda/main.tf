########################
# modules/lambda/main.tf
########################

resource "aws_iam_role" "lambda_exec" {
  name = "day10-lambda-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "app" {
  filename         = "./build/lambda_function_payload.zip" # local fallback
  function_name    = "day10-lambda"
  role             = aws_iam_role.lambda_exec.arn
  handler          = var.handler
  runtime          = var.runtime
  source_code_hash = filebase64sha256("./build/lambda_function_payload.zip")

  # if you prefer to pull from S3, uncomment the following and set s3_bucket/s3_key
  # s3_bucket = var.s3_bucket
  # s3_key    = var.s3_key
}

resource "aws_lambda_function_event_invoke_config" "config" {
  function_name = aws_lambda_function.app.function_name
  maximum_retry_attempts = 0
}