variable "region" {
  default = "us-east-1"
}

variable "name_prefix" {
  default = "surya"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  default = "10.0.1.0/24"
}

variable "ami_id" {
  default = "ami-0e86e20dae9224db8"
}

variable "instance_type" {
  default = "t2.micro"
}
