########################
# modules/ec2/variables.tf
########################

variable "subnet_id" {
  type = string
}

variable "security_grp_id" {
  type = string
}

variable "key_name" {
  type = string
}
