variable "region" {
  type    = string
  default = "ap-south-1"
}

variable "user_count" {
  type    = number
  default = 2
}

variable "user_prefix" {
  type    = string
  default = "dev-user"
}

variable "create_keys" {
  type    = bool
  default = false
}
