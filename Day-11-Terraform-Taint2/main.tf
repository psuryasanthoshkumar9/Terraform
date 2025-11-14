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

# -------------------------------
# 1. CREATE IAM USER
# -------------------------------
resource "aws_iam_user" "surya_user" {
  name = var.iam_user_name
}

# -------------------------------
# 2. CREATE IAM POLICY
# -------------------------------
resource "aws_iam_policy" "admin_policy" {
  name        = "${var.iam_user_name}-admin-policy"
  description = "Admin access policy for Surya"
  policy      = data.aws_iam_policy_document.admin_policy_doc.json
}

data "aws_iam_policy_document" "admin_policy_doc" {
  statement {
    actions   = ["*"]
    resources = ["*"]
  }
}

# -------------------------------
# 3. ATTACH POLICY TO USER
# -------------------------------
resource "aws_iam_user_policy_attachment" "attach_policy" {
  user       = aws_iam_user.surya_user.name
  policy_arn = aws_iam_policy.admin_policy.arn
}

# -------------------------------
# 4. ACCESS KEY & SECRET KEY
# -------------------------------
resource "aws_iam_access_key" "surya_key" {
  user = aws_iam_user.surya_user.name
}
