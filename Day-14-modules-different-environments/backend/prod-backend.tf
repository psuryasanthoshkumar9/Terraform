# Replace bucket & DynamoDB table names with your real prod backend resources
terraform {
  backend "s3" {
    bucket         = "prod-terraform-state-bucket-12345"
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "prod-tf-lock"
  }
}
