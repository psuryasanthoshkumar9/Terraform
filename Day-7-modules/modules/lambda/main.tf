resource "aws_lambda_function" "my_lambda" {
  function_name = var.lambda_function_name
  handler       = var.lambda_handler
  runtime       = var.lambda_runtime
  role          = var.role_arn
  filename      = "Lambda_function.zip"
  source_code_hash = filebase64sha256("Lambda_function.zip")

  memory_size = 128
  timeout     = 10

  tags = { Name = var.lambda_function_name }
}
