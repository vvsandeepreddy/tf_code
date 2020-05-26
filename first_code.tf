provider "aws" {
  profile = "default"
  region = "us-west-2"
}

resource "aws_s3_bucket" "first-terraform-bucket" {
  bucket = "terraform-first-bucket"
  acl = "private"
}
