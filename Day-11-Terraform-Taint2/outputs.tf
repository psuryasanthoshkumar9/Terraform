output "iam_access_key" {
  value     = aws_iam_access_key.surya_key.id
  sensitive = true
}

output "iam_secret_key" {
  value     = aws_iam_access_key.surya_key.secret
  sensitive = true
}
