output "iam_user_name" {
  value = aws_iam_user.surya_user.name
}

output "access_key" {
  value     = aws_iam_access_key.surya_key.id
  sensitive = true
}

output "secret_key" {
  value     = aws_iam_access_key.surya_key.secret
  sensitive = true
}

output "ec2_public_ip" {
  value = aws_instance.web.public_ip
}
