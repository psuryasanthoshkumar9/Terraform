# Dev Outputs
output "dev_user_name" {
  value = aws_iam_user.dev_user.name
}

output "dev_user_access_key" {
  value     = aws_iam_access_key.dev_user_key.id
  sensitive = true
}

output "dev_user_secret_key" {
  value     = aws_iam_access_key.dev_user_key.secret
  sensitive = true
}

# Prod Outputs
output "prod_user_name" {
  value = aws_iam_user.prod_user.name
}

output "prod_user_access_key" {
  value     = aws_iam_access_key.prod_user_key.id
  sensitive = true
}

output "prod_user_secret_key" {
  value     = aws_iam_access_key.prod_user_key.secret
  sensitive = true
}
