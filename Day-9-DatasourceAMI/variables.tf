variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type (free tier eligible)"
  type        = string
  default     = "t2.micro"
}

variable "sg_name" {
  description = "Security group name"
  type        = string
  default     = "web-sg"
}

variable "instance_name" {
  description = "EC2 instance Name tag"
  type        = string
  default     = "Terraform-Web-Server"
}

variable "ssh_cidr" {
  description = "CIDR range allowed for SSH"
  type        = string
  default     = "0.0.0.0/0"
}

variable "http_cidr" {
  description = "CIDR range allowed for HTTP"
  type        = string
  default     = "0.0.0.0/0"
}
