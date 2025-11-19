terraform {
  backend "s3" {
    bucket         = "dev-terraform-state-bucket-12345"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "dev-tf-lock"
  }
}
