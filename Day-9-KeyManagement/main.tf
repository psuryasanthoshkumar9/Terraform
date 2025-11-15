# Create KMS Key
resource "aws_kms_key" "my_kms" {
  description             = var.kms_description
  deletion_window_in_days = 7  # safe deletion period
  enable_key_rotation     = true
  tags = {
    Name = "Terraform-KMS-Key"
  }
}

# Create Alias for KMS Key
resource "aws_kms_alias" "my_kms_alias" {
  name          = var.kms_key_alias
  target_key_id = aws_kms_key.my_kms.id
}

# Example IAM Role to use the KMS Key
resource "aws_iam_role" "kms_role" {
  name = "kms-test-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

# Attach policy to allow KMS usage
resource "aws_iam_role_policy" "kms_role_policy" {
  name = "kms-role-policy"
  role = aws_iam_role.kms_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:GenerateDataKey"
        ]
        Effect   = "Allow"
        Resource = aws_kms_key.my_kms.arn
      }
    ]
  })
}
