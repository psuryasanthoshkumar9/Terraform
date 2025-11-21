output "iam_user_name" {
  value = aws_iam_user.surya_user.name
}

output "iam_access_key" {
  value     = aws_iam_access_key.surya_key.id
  sensitive = true
}

output "iam_secret_key" {
  value     = aws_iam_access_key.surya_key.secret
  sensitive = true
}
