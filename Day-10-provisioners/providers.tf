# Day-10-provisioners Terraform project
# This file bundles all Terraform files for the root and modules. Copy each section into its own file path as shown.


########################
# root: providers.tf
########################


provider "aws" {
  region = var.aws_region
}