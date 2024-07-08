locals {
  region  = "eu-central-1"
}

provider "aws" {
  region = local.region

  default_tags {
    tags = {
      tf      = "true"
    }
  }
}

resource "aws_s3_bucket" "state" {
  bucket = "tf-state-xvjqwblrsf"
}

# You have to comment it out if you want to create S3 bucket at first
terraform {
  backend "s3" {
    bucket = "tf-state-xvjqwblrsf"
    key    = "terraform.tfstate"
    region = "eu-central-1"
  }
}
