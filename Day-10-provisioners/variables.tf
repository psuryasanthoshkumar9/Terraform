########################
# root: variables.tf
########################

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "key_name" {
  description = "SSH key pair name for EC2"
  type        = string
  default     = "my-ec2-key"
}

variable "db_username" {
  type    = string
  default = "admin"
}

variable "db_password" {
  type    = string
  default = "ChangeMe123!"
}

variable "app_bucket" {
  description = "S3 bucket name to store Lambda artifact"
  type        = string
  default     = "my-lambda-artifacts-bucket-12345"
}