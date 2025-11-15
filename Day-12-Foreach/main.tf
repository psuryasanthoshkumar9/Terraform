locals {
  name_prefix = "surya-${var.env}"
}

# ---------------------------
# Create VPC
# ---------------------------
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "${local.name_prefix}-vpc"
  }
}

# ---------------------------
# Create Subnets using for_each
# ---------------------------
resource "aws_subnet" "subnets" {
  for_each = var.subnets

  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.az
  map_public_ip_on_launch = true

  tags = {
    Name = "${local.name_prefix}-${each.key}"
  }
}

# ---------------------------
# Create S3 buckets using for_each
# ---------------------------
resource "aws_s3_bucket" "buckets" {
  for_each = var.buckets

  bucket        = "${local.name_prefix}-${each.value}"
  force_destroy = true

  tags = {
    Name = "${local.name_prefix}-${each.key}"
  }
}
