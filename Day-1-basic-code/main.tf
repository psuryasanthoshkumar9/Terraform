resource "aws_vpc" "dev" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "dev_VPC"
  }
}

resource "aws_subnet" "dev_subnet" {
  vpc_id     = aws_vpc.dev.id
  cidr_block = "10.0.1.0/24"   # <<< THIS IS REQUIRED
  availability_zone = "us-east-1a"
  tags = {
    Name = "dev_subnet"
  }
}
