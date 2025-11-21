variable "project_name" { type = string }
variable "environment" { type = string }
variable "vpc_id"      { type = string }
variable "subnets_ids" { type = list(string) }
variable "ami"         { type = string }
variable "instance_type" { type = string }
variable "instance_count" { type = number }
variable "security_group_ids" {
  type = list(string)
  description = "List of security group IDs to assign to EC2 instances"
}
