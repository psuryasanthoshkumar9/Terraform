output "role_name" {
  value = aws_iam_role.lambda_exec_role.name
}

output "role_arn" {
  value = aws_iam_role.lambda_exec_role.arn
}
