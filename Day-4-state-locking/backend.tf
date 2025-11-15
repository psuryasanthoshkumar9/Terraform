terraform {
  backend "s3" {
    bucket = "pingala"
    key    = "day3/terraform.tfstate"
    #use_lockfile = true #to use S3 native locking
    region = "us-east-1"
    dynamodb_table = "Krishna"
    encrypt = true
  }
}
