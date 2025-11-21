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

resource "aws_iam_user" "iam_user" {
  name = "${var.user_name}-user"
  tags = {
    CreatedBy = "Terraform"
  }
}

data "aws_iam_policy_document" "custom_policy" {
  statement {
    effect = "Allow"

    actions = [
      "ec2:*",
      "s3:*",
      "iam:*",
      "lambda:*"
    ]

    resources = ["*"]
  }
}

resource "aws_iam_policy" "policy" {
  name        = "${var.user_name}-policy"
  description = "Custom admin-like policy for user"
  policy      = data.aws_iam_policy_document.custom_policy.json
}

resource "aws_iam_user_policy_attachment" "attach" {
  user       = aws_iam_user.iam_user.name
  policy_arn = aws_iam_policy.policy.arn
}

resource "aws_iam_access_key" "access" {
  user = aws_iam_user.iam_user.name
}
