variable "allowed_ports" {
  type    = list(number)
  default = [22, 80, 443]
}

variable "cidr_block" {
  type    = string
  default = "0.0.0.0/0"
}
