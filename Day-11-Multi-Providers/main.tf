# ------------------
# Dev IAM User
# ------------------
resource "aws_iam_user" "dev_user" {
  provider = aws.dev
  name     = var.dev_user_name
  path     = "/"
}

resource "aws_iam_access_key" "dev_user_key" {
  provider = aws.dev
  user     = aws_iam_user.dev_user.name
}

# ------------------
# Prod IAM User
# ------------------
resource "aws_iam_user" "prod_user" {
  provider = aws.prod
  name     = var.prod_user_name
  path     = "/"
}

resource "aws_iam_access_key" "prod_user_key" {
  provider = aws.prod
  user     = aws_iam_user.prod_user.name
}
