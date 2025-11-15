output "dev_user_access_key" {
  value = aws_iam_access_key.dev_user_key.id
}

output "dev_user_secret_key" {
  value     = aws_iam_access_key.dev_user_key.secret
  sensitive = true
}

output "prod_user_access_key" {
  value = aws_iam_access_key.prod_user_key.id
}

output "prod_user_secret_key" {
  value     = aws_iam_access_key.prod_user_key.secret
  sensitive = true
}
