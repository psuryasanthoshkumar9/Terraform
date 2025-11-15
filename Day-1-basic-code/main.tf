resource "aws_vpc" "dev" {
    cidr_block = "10.0.0.0/16"
    tags = {
Name = "dev_VPC"
    }
  }
  resource "aws_vpc" "test" {
    cidr_block = "10.0.0.0/16"
    tags = {
Name = "dev_VPC"
    }
  }
  resource "aws_subnet" "dev_subnet" {
    vpc_id = aws_vpc.dev.id
  }