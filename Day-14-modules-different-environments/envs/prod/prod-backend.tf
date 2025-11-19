terraform {
  backend "s3" {
    bucket         = "prod-terraform-state-bucket-12345"
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "prod-tf-lock"
  }
}
