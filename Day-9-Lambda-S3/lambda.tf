# Create Lambda Function using code from S3
resource "aws_lambda_function" "lambda_from_s3" {
  function_name = "TerraformLambdaFromS3"
  role          = aws_iam_role.lambda_exec_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"

  # Pull the code from S3
  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_object.lambda_zip.key

  environment {
    variables = {
      ENV = "TerraformS3Demo"
    }
  }

  depends_on = [
    aws_iam_role_policy_attachment.lambda_policy
  ]
}

# Output Lambda ARN
output "lambda_function_arn" {
  value = aws_lambda_function.lambda_from_s3.arn
}

# Output S3 bucket name
output "s3_bucket_name" {
  value = aws_s3_bucket.lambda_bucket.bucket
}
