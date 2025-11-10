variable "lambda_function_name" {
  default = "terraform-lambda-s3"
}

variable "lambda_handler" {
  default = "lambda_function.lambda_handler"
}

variable "lambda_runtime" {
  default = "python3.11"
}

variable "s3_bucket" {
  description = "S3 bucket where Lambda zip is stored"
  default     = "my-lambda-bucket"   # Change this to your bucket name
}

variable "s3_key" {
  description = "S3 object key for Lambda zip"
  default     = "lambda_function.zip"
}
