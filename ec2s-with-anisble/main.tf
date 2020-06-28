provider "aws" {
  profile = "default"
  region  = "us-west-2"
}

resource "aws_instance" "ansible-master" {
  ami               = "ami-0e781a2535d5b2d02"
  instance_type     = "t2.micro"
  key_name          = "terraform-ec2"

provisioner "remote-exec" {
  inline  = [
    "sudo yum install git -y",
    "sudo amazon-linux-extras install ansible2 -y",
    "mkdir -p Ansible/Inventory"
 ]
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("terraform-ec2.pem")
    host        = "${aws_instance.ansible-master.public_ip}"
    timeout     = "30s"
 }
}

tags = {
    type = "Anisble"
}
}

resource "aws_instance" "ansible-workers" {
  ami               = "ami-0e781a2535d5b2d02"
  instance_type     = "t2.micro"
  key_name          = "terraform-ec2"
  count             = 2
 }


module "inventory_production" {
  source  = "gendall/ansible-inventory/local"
  servers = {
    manager = ["${aws_instance.ansible-master.public_ip}"]
    worker = ["${aws_instance.ansible-workers.0.public_ip} ansible_ssh_private_key_file=terraform-ec2.pem", "${aws_instance.ansible-workers.1.public_ip} ansible_ssh_private_key_file=terraform-ec2.pem"]
  }
  secrets = {
    tls_key  = "-----BEGIN RSA PRIVATE KEY----- MIIEow..."
    tls_cert = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD..."
  }
  output  = "inventory/production"
}

resource "null_resource" "copy-step" {
  depends_on = ["aws_instance.ansible-master","aws_instance.ansible-workers", "module.inventory_production"]
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("terraform-ec2.pem")
    host        = "${aws_instance.ansible-master.public_ip}"
    timeout     = "30s"
   }

  provisioner "file" {
    source      = "inventory/production/"
    destination = "/home/ec2-user/Ansible/Inventory"
    }
}
