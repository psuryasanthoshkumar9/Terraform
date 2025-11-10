# Create S3 bucket to store Lambda code
resource "aws_s3_bucket" "lambda_bucket" {
  bucket = "pingala-take-bucket"   # Your bucket name
  force_destroy = true

  tags = {
    Name = "LambdaSourceBucket"
  }
}

# Upload the lambda zip file to S3
resource "aws_s3_object" "lambda_zip" {
  bucket = aws_s3_bucket.lambda_bucket.id
  key    = "lambda_function.zip"
  source = "lambda_function.zip"        # Must exist locally
  etag   = filemd5("lambda_function.zip")
}
