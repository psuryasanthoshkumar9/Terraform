terraform {
  backend "s3" {
    bucket = "pingala"
    key    = "day3/terraform.tfstate"
    region = "us-east-1"
  }
}
