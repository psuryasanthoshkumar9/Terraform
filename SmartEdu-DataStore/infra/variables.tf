# -----------------------------
# AWS Region
# -----------------------------
variable "region" {
  description = "AWS region to deploy resources"
  default     = "us-east-1"
}

# -----------------------------
# Project Name
# -----------------------------
variable "project_name" {
  description = "Name prefix for all AWS resources"
  default     = "SmartEdu-DataStore"
}

# -----------------------------
# EC2 Instance Type
# -----------------------------
variable "instance_type" {
  description = "EC2 instance type for CI/CD server"
  default     = "t3.medium"
}

# -----------------------------
# RDS Credentials
# -----------------------------
variable "db_username" {
  description = "MySQL username"
  default     = "admin"
}

variable "db_password" {
  description = "MySQL root password"
  sensitive   = true
  default     = "Cloud123"
}
