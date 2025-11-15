terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

resource "aws_iam_user" "dev_user" {
  count = var.user_count
  name  = "${var.user_prefix}-${count.index}"
  tags = {
    environment = "dev"
  }
}

# Optional: create access keys only if create_keys true
resource "aws_iam_access_key" "dev_key" {
  count = var.create_keys ? var.user_count : 0
  user  = aws_iam_user.dev_user[count.index].name
}
