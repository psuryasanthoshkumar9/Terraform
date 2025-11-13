########################
# modules/lambda/variables.tf
########################

variable "s3_bucket" {
  type = string
}

variable "s3_key" {
  type = string
}

variable "handler" {
  type = string
}

variable "runtime" {
  type = string
}

variable "lambda_sg_id" {
  type = string
}