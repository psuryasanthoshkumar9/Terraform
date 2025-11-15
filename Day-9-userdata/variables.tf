variable "aws_region" {
  description = "AWS region to deploy resources"
  default     = "us-east-1"
}

variable "ami_id" {
  description = "Amazon Linux 2 AMI ID (update if region differs)"
  # Latest Free Tier AMI for us-east-1
  default     = "ami-0f9fc25dd2506cf6d"
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.micro"
}

variable "key_name" {
  description = "Key pair name for SSH"
  default     = "my-keypair"
}
