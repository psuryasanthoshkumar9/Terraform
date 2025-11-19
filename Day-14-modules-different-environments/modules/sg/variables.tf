variable "environment" {
  type = string
  description = "Environment name (dev/test/prod)"
}

variable "vpc_id" {
  type = string
  description = "VPC ID where the SG will be created"
}
