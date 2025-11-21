resource "random_string" "suffix" {
  length  = 6
  upper   = false
  numeric = true
  special = false
}

resource "aws_s3_bucket" "demo" {
  bucket = "opentofu-demo-bucket-${random_string.suffix.result}"

  tags = {
    Name = "Day15-OpenTofu"
    Env  = "Dev"
  }
}
