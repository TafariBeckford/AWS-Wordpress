
module "autoscale_group" {
  source = "cloudposse/ec2-autoscale-group/aws"
  # version = "x.x.x"


  name = var.name

  image_id                    = "ami-0a42fa6f2e303617d"
  instance_type               = var.instance_type
  iam_instance_profile_name   = var.iam_instance_profile_name
  security_group_ids          = [module.wordpress_sg.security_group_id]
  subnet_ids                  = module.wordpress-vpc.public_subnets
  health_check_type           = "EC2"
  min_size                    = 1
  desired_capacity            = 1
  max_size                    = 3
  wait_for_capacity_timeout   = "5m"
  associate_public_ip_address = true
  user_data_base64            = base64encode(local.userdata)
  default_cooldown            = 300

  target_group_arns = module.alb.target_group_arns




  # Auto-scaling policies and CloudWatch metric alarms
  autoscaling_policies_enabled           = true
  cpu_utilization_high_threshold_percent = "40"
  cpu_utilization_low_threshold_percent  = "30"
}