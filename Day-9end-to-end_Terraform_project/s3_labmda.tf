resource "aws_s3_bucket" "lambda_bucket" {
  bucket = "${var.project_prefix}-lambda-bucket-${random_string.suffix.result}"
  force_destroy = true
  tags = { Name = "${var.project_prefix}-lambda-bucket" }
}

resource "aws_s3_object" "lambda_zip" {
  bucket = aws_s3_bucket.lambda_bucket.id
  key    = "lambda_function.zip"
  source = "lambda_function.zip"
  etag   = filemd5("lambda_function.zip")
  content_type = "application/zip"
}
