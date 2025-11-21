variable "region" {
  type    = string
  default = "us-east-1"
}

variable "env" {
  type    = string
  default = "sandbox"
}

variable "name_prefix" {
  type    = string
  default = "surya"
}

variable "lambda_runtime" {
  type    = string
  default = "python3.9"
}

variable "lambda_handler" {
  type    = string
  default = "lambda_function.lambda_handler"
}

# Path to the zip file (relative to working directory)
variable "lambda_zip_path" {
  type    = string
  default = "lambda.zip"
}
