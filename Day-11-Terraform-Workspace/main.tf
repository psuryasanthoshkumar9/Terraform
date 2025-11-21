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
# IAM USER (Unique per workspace + random suffix)
# -------------------------------
resource "aws_iam_user" "surya_user" {
  name          = "SuryaTerraformUser-${terraform.workspace}-${random_id.user_suffix.hex}"
  force_destroy = true
}

# -------------------------------
# RANDOM SUFFIX
# -------------------------------
resource "random_id" "user_suffix" {
  byte_length = 2
}

# -------------------------------
# IAM POLICY (Unique per workspace + random suffix)
# -------------------------------
data "aws_iam_policy_document" "admin_policy_doc" {
  statement {
    actions   = ["*"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "admin_policy" {
  name        = "SuryaTerraformUser-admin-policy-${terraform.workspace}-${random_id.user_suffix.hex}"
  description = "Admin access policy for Surya"
  policy      = data.aws_iam_policy_document.admin_policy_doc.json
}

# -------------------------------
# Attach Policy to User
# -------------------------------
resource "aws_iam_user_policy_attachment" "attach_policy" {
  user       = aws_iam_user.surya_user.name
  policy_arn = aws_iam_policy.admin_policy.arn
}

# -------------------------------
# IAM ACCESS KEY (Taintable)
# -------------------------------
resource "aws_iam_access_key" "surya_key" {
  user = aws_iam_user.surya_user.name
}
