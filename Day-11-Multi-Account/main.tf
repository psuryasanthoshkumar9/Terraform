# IAM Users
resource "aws_iam_user" "dev_user" {
  name = "dev-user"
  path = "/"
}

resource "aws_iam_user" "prod_user" {
  name = "prod-user"
  path = "/"
}

# IAM Access Keys for Users
resource "aws_iam_access_key" "dev_user_key" {
  user = aws_iam_user.dev_user.name
}

resource "aws_iam_access_key" "prod_user_key" {
  user = aws_iam_user.prod_user.name
}

# IAM Policy (optional) - Attach Administrator Access
resource "aws_iam_user_policy_attachment" "dev_user_attach" {
  user       = aws_iam_user.dev_user.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_user_policy_attachment" "prod_user_attach" {
  user       = aws_iam_user.prod_user.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

