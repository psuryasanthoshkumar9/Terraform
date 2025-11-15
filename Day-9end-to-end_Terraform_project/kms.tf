resource "aws_kms_key" "cmk" {
  description             = "${var.project_prefix} Terraform-managed KMS key"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  tags = {
    Name = "${var.project_prefix}-kms-${random_string.suffix.result}"
  }
}

resource "aws_kms_alias" "cmk_alias" {
  name          = "alias/${var.project_prefix}-key-${random_string.suffix.result}"
  target_key_id = aws_kms_key.cmk.id
}
