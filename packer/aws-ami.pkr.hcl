
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
  vpc_id = "vpc-0842877808b9b705e"
  subnet_id = "subnet-07c00ab73c1effa55"
  security_group_id = "sg-0101fd2d1db4a18f1"
  




  tags = {
    "Name" = "Wordpress"
  }
}

build {

  sources = ["source.amazon-ebs.ubuntu"]

  provisioner "shell" {

    script = "../scripts/wordpress.sh"

  }

  post-processor "manifest" {}

}