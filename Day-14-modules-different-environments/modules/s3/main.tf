resource "aws_s3_bucket" "this" {
  bucket        = "${var.project_name}-${var.environment}-bucket"
  force_destroy = true
}

output "bucket_name" {
  value = aws_s3_bucket.this.id
}
