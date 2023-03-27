
module "efs" {
  source = "cloudposse/efs/aws"
  # version     = "x.x.x"

  name      = "wordpress-content"
  region    = "us-east-1"
  vpc_id    = module.wordpress-vpc.vpc_id
  subnets   = module.wordpress-vpc.private_subnets
  create_security_group = false

  associated_security_group_ids = [module.efs_sg.security_group_id]
  
  }

 