output "user_names" {
  value = aws_iam_user.dev_user[*].name
}

output "access_key_ids" {
  value     = var.create_keys ? aws_iam_access_key.dev_key[*].id : []
  sensitive = true
}
