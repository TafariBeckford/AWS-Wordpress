module "wordpress_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "wordpress-security-group"
  description = "Security group for Wordpress publicly open"
  vpc_id      = module.wordpress-vpc.vpc_id

  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["all-all"]
  

  computed_ingress_with_cidr_blocks = [
    {
      rule        = "http-80-tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
     rule = "ssh-tcp"
     cidr_blocks = "${chomp(data.http.myip.body)}/32"
    }
  ]
  number_of_computed_ingress_with_cidr_blocks = 2
}


module "database_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "rds-security-group"
  description = "Security group to open SQL within the VPC"
  vpc_id      = module.wordpress-vpc.vpc_id

  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["all-all"]

  computed_ingress_with_source_security_group_id = [
    {
      rule                     = "mysql-tcp"
      source_security_group_id = module.wordpress_sg.security_group_id
    }
  ]
  number_of_computed_ingress_with_source_security_group_id = 1



}


module "efs_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "efs-security-group"
  description = "Control access to EFS"
  vpc_id      = module.wordpress-vpc.vpc_id

  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["all-all"]

  computed_ingress_with_source_security_group_id = [
    {
      rule                     = "nfs-tcp"
      source_security_group_id = module.wordpress_sg.security_group_id
    }

  ]
  number_of_computed_ingress_with_source_security_group_id = 1


}


module "loadBalancer_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "LoadBalancer-security-group"
  description = "Allow HTTP IPv4 IN"
  vpc_id      = module.wordpress-vpc.vpc_id

  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["all-all"]

  computed_ingress_with_cidr_blocks = [
    {
      rule        = "http-80-tcp"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  number_of_computed_ingress_with_cidr_blocks = 1

}


