provider "aws" {
    region = "ap-southeast-2"
}

terraform {
  backend "s3" {
    bucket = "viet-tf-state"
    key    = "dev/terraform.tfstate"
  }
}