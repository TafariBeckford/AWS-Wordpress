module "wordpress-vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "wordpress-vpc"
  cidr = var.cidr_block

  azs                   = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets       = slice(cidrsubnets(var.cidr_block, 4, 4, 4, 4, 4, 4, 4, 4, 4), 0, 3)
  public_subnets        = slice(cidrsubnets(var.cidr_block, 4, 4, 4, 4, 4, 4, 4, 4, 4), 3, 6)
  database_subnets      = slice(cidrsubnets(var.cidr_block, 4, 4, 4, 4, 4, 4, 4, 4, 4), 6, 9)
  database_subnet_names = ["db-a", "db-b", "db-c"]
  private_subnet_names  = ["app-a", "app-b", "app-c"]
  public_subnet_names   = ["pub-a", "pub-b", "pub-c"]
  enable_dns_hostnames = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}