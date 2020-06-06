provider "aws" {
  profile = "default"
  region  = "us-west-2"
}

resource "aws_s3_bucket" "first-terraform-bucket" {
  bucket = "terraform-first-bucket"
  acl    = "private"
}

resource "aws_instance" "first-ec2-instance" {
  count             = 2
  ami               = "ami-0e781a2535d5b2d02"
  instance_type     = "t2.micro"
  key_name          = "terraform-ec2"

  tags = {
    Name = "terraform"
    }
 


}
