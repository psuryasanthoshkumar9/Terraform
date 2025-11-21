resource "aws_iam_role" "lambda_exec_role" {
  name = "${var.project_prefix}-lambda-role-${random_string.suffix.result}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "from_s3" {
  function_name = "${var.lambda_function_name}-${random_string.suffix.result}"
  role          = aws_iam_role.lambda_exec_role.arn
  handler       = var.lambda_handler
  runtime       = var.lambda_runtime

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_object.lambda_zip.key

  memory_size = 128
  timeout     = 10

  environment {
    variables = {
      ENV = "dev"
    }
  }

  depends_on = [
    aws_iam_role_policy_attachment.lambda_logs,
    aws_s3_object.lambda_zip
  ]
}
