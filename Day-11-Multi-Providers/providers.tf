provider "aws" {
  alias   = "dev"
  region  = "us-east-1"
  profile = "default"  # Your AWS CLI profile for dev
}

provider "aws" {
  alias   = "prod"
  region  = "us-east-1"
  profile = "default"  # Your AWS CLI profile for prod
}
