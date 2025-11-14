output "iam_access_key" {
  value     = aws_iam_access_key.access.id
  sensitive = true
}

output "iam_secret_key" {
  value     = aws_iam_access_key.access.secret
  sensitive = true
}
