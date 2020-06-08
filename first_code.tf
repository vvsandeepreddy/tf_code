provider "aws" {
  profile = "default"
  region  = var.region
}

module "website_s3_bucket" {
  source      = "./modules/aws-s3-static-website-bucket"
  bucket_name = "first-dev-terraform-bucket"

tags = {
  type = "terraform"
  Env  = "dev"
}
}

resource "aws_instance" "first-dev-ec2-instance" {
  count             = 2
  ami               = "ami-0e781a2535d5b2d02"
  instance_type     = "t2.micro"
  key_name          = "terraform-ec2"
  depends_on        = [module.website_s3_bucket]
tags = {
    type = "terraform"
    Env  = "dev"
}
}

resource "aws_eip" "first-dev-eip" {
  count     = 2
  instance  = aws_instance.first-dev-ec2-instance.*.id[count.index]
  vpc       = true

}
