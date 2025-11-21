variable "project_name" { type = string }
variable "environment"  { type = string }
variable "instance_class" { type = string }
variable "db_name"      { type = string }
variable "db_username"  { type = string }
variable "subnets_ids"  { type = list(string) }
variable "security_group_ids" { type = list(string) }