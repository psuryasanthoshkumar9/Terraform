locals {
  project_name  = "day11-locals"
  environment   = "dev"
  instance_type = "t2.micro"

  tags = {
    Project     = local.project_name
    Environment = local.environment
    Owner       = "Surya"
  }
}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags       = local.tags
}

resource "aws_instance" "example" {
  ami           = "ami-0c02fb55956c7d316" # Amazon Linux 2
  instance_type = local.instance_type

  tags = merge(
    local.tags,
    { Name = "${local.project_name}-ec2" }
  )
}
