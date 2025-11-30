variable "region" {
  default = "us-east-1"
}
variable "key_name" {
  description = "EC2 key pair name (optional, required for SSH)"
  default     = ""
}
variable "public_key_path" {
  description = "Path to public key (optional)"
  default     = ""
}
variable "instance_type" {
  default = "t3.medium"
}
variable "db_username" {
  default = "admin"
}
variable "db_password" {
  description = "MySQL RDS password (override)"
  default     = "Cloud123"
  sensitive   = true
}
variable "project_name" {
  default = "SmartEdu-DataStore"
}
