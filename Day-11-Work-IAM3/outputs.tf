output "iam_access_key" {
  value     = aws_iam_access_key.surya_access_key.id
  sensitive = true
}

output "iam_secret_key" {
  value     = aws_iam_access_key.surya_access_key.secret
  sensitive = true
}

output "iam_role_arn" {
  value = aws_iam_role.surya_role.arn
}

output "ec2_instance_profile_arn" {
  value = aws_iam_instance_profile.ec2_profile.arn
}
