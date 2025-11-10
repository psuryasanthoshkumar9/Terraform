variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "key_name" {
  type = string
}

variable "lambda_s3_bucket" {
  type = string
}

variable "lambda_function_name" {
  type = string
}

variable "lambda_handler" {
  type    = string
  default = "lambda_function.lambda_handler"
}

variable "lambda_runtime" {
  type    = string
  default = "python3.9"
}
