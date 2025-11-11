resource "aws_lambda_function" "my_lambda" {
  function_name = "tf-lambda"
  handler       = "Lambda_function.lambda_handler"
  runtime       = "python3.9"
  role          = var.role_arn

  s3_bucket = var.s3_bucket
  s3_key    = var.s3_key

  memory_size = 128
  timeout     = 10
}
