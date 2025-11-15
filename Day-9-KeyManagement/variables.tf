variable "kms_key_alias" {
  description = "Alias name for the KMS Key"
  default     = "alias/my-key"
}

variable "kms_description" {
  description = "Description for KMS Key"
  default     = "Terraform managed KMS key"
}
