provider "aws" {
  profile = "default"
  region = "us-west-2"
}

resource "aws_s3_bucket" "first_terraform_bucket" {
  bucket = "terraform_first_bucket"
  acl = "private"
}
