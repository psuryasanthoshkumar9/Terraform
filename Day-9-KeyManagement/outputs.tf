output "kms_key_id" {
  description = "ID of the KMS key"
  value       = aws_kms_key.my_kms.id
}

output "kms_key_arn" {
  description = "ARN of the KMS key"
  value       = aws_kms_key.my_kms.arn
}

output "kms_key_alias" {
  description = "Alias of the KMS key"
  value       = aws_kms_alias.my_kms_alias.name
}
