variable "region" { type = string, default = "us-east-1" }
variable "environment" { type = string, default = "test" }
variable "instance_type" { type = string, default = "t2.small" }
variable "vpc_cidr" { type = string, default = "10.20.0.0/16" }
variable "public_subnet_cidr" { type = string, default = "10.20.1.0/24" }
variable "rds_password" { type = string, sensitive = true, default = "Test123!" }
