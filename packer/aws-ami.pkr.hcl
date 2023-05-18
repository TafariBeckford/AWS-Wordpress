
locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

source "amazon-ebs" "ubuntu" {
  ami_name             = "Wordpress-${local.timestamp}"
  region               = "us-east-1"
  instance_type        = "t2.micro"
  source_ami           = "ami-005f9685cb30f234b"
  ssh_username         = "ec2-user"
  iam_instance_profile = "PackerIamRole"
  vpc_id               = "vpc-0dbba48a30e9f0f2e"

  


  tags = {
    "Name" = "Wordpress"
  }
}

build {

  sources = ["source.amazon-ebs.ubuntu"]

  provisioner "ansible" {

    playbook_file = "../ansible-playbook/playbook.yml"

  }

  post-processor "manifest" {}

}