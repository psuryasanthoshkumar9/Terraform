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

# ---------------------------
# 1) IAM USER
# ---------------------------
resource "aws_iam_user" "surya_user" {
  name = "${var.user_name}-user"
  tags = {
    CreatedBy = "Terraform"
  }
}

# ---------------------------
# 2) IAM GROUP
# ---------------------------
resource "aws_iam_group" "surya_group" {
  name = "${var.user_name}-group"
}

# Add user to group
resource "aws_iam_group_membership" "group_membership" {
  name  = "${var.user_name}-group-members"
  users = [aws_iam_user.surya_user.name]
  group = aws_iam_group.surya_group.name
}

# ---------------------------
# 3) POLICY DOCUMENT
# ---------------------------
data "aws_iam_policy_document" "custom_policy_doc" {
  statement {
    effect = "Allow"
    actions = [
      "s3:*",
      "ec2:*",
      "iam:*"
    ]
    resources = ["*"]
  }
}

# ---------------------------
# 4) IAM POLICY
# ---------------------------
resource "aws_iam_policy" "custom_policy" {
  name   = "${var.user_name}-custom-policy"
  policy = data.aws_iam_policy_document.custom_policy_doc.json
}

# Attach policy to Group
resource "aws_iam_group_policy_attachment" "attach_policy_group" {
  group      = aws_iam_group.surya_group.name
  policy_arn = aws_iam_policy.custom_policy.arn
}

# ---------------------------
# 5) IAM ACCESS KEY
# ---------------------------
resource "aws_iam_access_key" "surya_access_key" {
  user = aws_iam_user.surya_user.name
}

# ---------------------------
# 6) IAM ROLE
# ---------------------------
data "aws_iam_policy_document" "assume_role_doc" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = [aws_iam_user.surya_user.arn]
    }
  }
}

resource "aws_iam_role" "surya_role" {
  name               = "${var.user_name}-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_doc.json
}

# ---------------------------
# 7) INLINE POLICY (FOR ROLE)
# ---------------------------
resource "aws_iam_role_policy" "inline_role_policy" {
  name = "${var.user_name}-role-inline-policy"
  role = aws_iam_role.surya_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect   = "Allow",
      Action   = ["lambda:*"],
      Resource = "*"
    }]
  })
}
