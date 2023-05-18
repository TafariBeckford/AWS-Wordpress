variable "cidr_block" {
  type    = string
  default = "10.17.0.0/16"
}

variable "password" {
  sensitive = true
  type = string 
  default = "admin12345"
}

variable "instance_type" {
type = string
default = "t3.micro"
  
}

locals {
  userdata = <<-USERDATA
    #!/bin/bash
  sudo service httpd restart
  USERDATA
}

variable "iam_instance_profile_name"{
  type = string
  default =""
}

variable "name" {
  type = string
  default = "wordpress-asg"
  
}