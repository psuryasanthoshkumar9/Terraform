terraform {
  backend "s3" {
    bucket         = "test-terraform-state-bucket-12345"
    key            = "test/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "test-tf-lock"
  }
}
