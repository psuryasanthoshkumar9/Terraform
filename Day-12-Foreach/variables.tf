variable "env" {
  type    = string
  default = "dev"
}

variable "subnets" {
  type = map(object({
    cidr_block = string
    az         = string
  }))

  default = {
    public1 = {
      cidr_block = "10.0.1.0/24"
      az         = "us-east-1a"
    }
    public2 = {
      cidr_block = "10.0.2.0/24"
      az         = "us-east-1b"
    }
  }
}

variable "buckets" {
  type = map(string)

  default = {
    logs    = "app-logs"
    reports = "app-reports"
    data    = "app-data"
  }
}
