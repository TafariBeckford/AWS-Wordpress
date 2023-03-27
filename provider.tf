terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.57.1"
    }
  }
}


data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}