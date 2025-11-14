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

# --------------------------------------------------------
# 1) IAM USER
# --------------------------------------------------------
resource "aws_iam_user" "surya_user" {
  name = "${var.user_name}-user"
  tags = {
    CreatedBy = "Terraform"
  }
}

# --------------------------------------------------------
# 2) IAM GROUP
# --------------------------------------------------------
resource "aws_iam_group" "surya_group" {
  name = "${var.user_name}-group"
}

resource "aws_iam_group_membership" "group_membership" {
  name  = "${var.user_name}-group-membership"
  users = [aws_iam_user.surya_user.name]
  group = aws_iam_group.surya_group.name
}

# --------------------------------------------------------
# 3) POLICY DOCUMENT FOR GROUP
# --------------------------------------------------------
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

resource "aws_iam_policy" "custom_policy" {
  name   = "${var.user_name}-custom-policy"
  policy = data.aws_iam_policy_document.custom_policy_doc.json
}

resource "aws_iam_group_policy_attachment" "attach_policy_group" {
  group      = aws_iam_group.surya_group.name
  policy_arn = aws_iam_policy.custom_policy.arn
}

# --------------------------------------------------------
# 4) IAM ACCESS KEY
# --------------------------------------------------------
resource "aws_iam_access_key" "surya_access_key" {
  user = aws_iam_user.surya_user.name
}

# --------------------------------------------------------
# 5) IAM ROLE (ASSUMED BY USER)
# --------------------------------------------------------
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
  name               = "${var.user_name}-assume-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_doc.json
}

resource "aws_iam_role_policy" "inline_role_policy" {
  name = "${var.user_name}-inline-role-policy"
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

# --------------------------------------------------------
# 6) EC2 IAM ROLE (Service Role)
# --------------------------------------------------------
data "aws_iam_policy_document" "ec2_assume_role_doc" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ec2_role" {
  name               = "${var.user_name}-ec2-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role_doc.json
}

resource "aws_iam_policy" "ec2_s3_policy" {
  name = "${var.user_name}-ec2-s3-policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect   = "Allow",
      Action   = ["s3:*"],
      Resource = "*"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "attach_ec2_policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.ec2_s3_policy.arn
}

# EC2 requires Instance Profile
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.user_name}-instance-profile"
  role = aws_iam_role.ec2_role.name
}
