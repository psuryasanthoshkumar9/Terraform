terraform {
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "~> 3.0"
    }
  }
}

provider "null" {}

resource "null_resource" "example" {
  count = var.instance_count

  triggers = {
    name = "example-${count.index}"
  }
}
