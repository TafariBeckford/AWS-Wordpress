module "db" {
  source = "terraform-aws-modules/rds/aws"

  identifier = "wordpress-db-instance"

  engine            = "mysql"
  engine_version    = "8.0.28"
  instance_class    = "db.t3.micro"
  allocated_storage = 5

  db_name                = "wordpress"
  username               = "admin"
  password               = var.password
  create_random_password = true
  port                   = "3306"

  iam_database_authentication_enabled = true

  vpc_security_group_ids = [module.database_sg.security_group_id]


  tags = {
    Owner       = "user"
    Environment = "dev"
  }

  # DB subnet group
  create_db_subnet_group = true
  db_subnet_group_name   = "wordpress-db-group"

  create_db_option_group    = false
  create_db_parameter_group = false

  subnet_ids = module.wordpress-vpc.database_subnets
}