module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 8.0"

  name = "wordpress-alb"

  load_balancer_type = "application"

  vpc_id             = module.wordpress-vpc.vpc_id
  subnets            = module.wordpress-vpc.public_subnets
  security_groups    = [module.loadBalancer_sg.security_group_id]


  target_groups = [
    {
      name_prefix      = "wp-"
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
    }
  ]
   http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
    }
  ]
}