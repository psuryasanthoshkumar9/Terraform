terraform {
  backend "s3" {
    bucket = "pingala"
    key    = "day2/terraform.tfstate"
    region = "us-east-1"
  }
}
