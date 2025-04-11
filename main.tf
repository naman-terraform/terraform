# Added test resource for dev validation

module "vpc" {
  source = "./modules/vpc"

  # Basic Configuration
  project_name = var.project_name
  vpc_cidr     = var.vpc_cidr

  # Dynamic AZ and Subnet Configuration
  availability_zones = [
    for i in range(var.az_count) :
    "${var.aws_region}${substr("abcdefghijk", i, 1)}"
  ]

  public_subnet_cidrs = [
    for i in range(var.az_count) :
    cidrsubnet(var.vpc_cidr, var.subnet_bits, i)
  ]

  private_subnet_cidrs = [
    for i in range(var.az_count) :
    cidrsubnet(var.vpc_cidr, var.subnet_bits, i + var.az_count)
  ]

  database_subnet_cidrs = [
    for i in range(var.az_count) :
    cidrsubnet(var.vpc_cidr, var.subnet_bits, i + (2 * var.az_count))
  ]

  # Feature Flags
  enable_nat_gateway              = var.enable_nat_gateway
  enable_flow_logs                = var.enable_flow_logs
  single_nat_gateway              = var.single_nat_gateway
  enable_ipv6                     = var.enable_ipv6
  assign_ipv6_address_on_creation = var.assign_ipv6_address_on_creation

  # Tags
  tags = var.tags
}


module "security_group" {
  source = "./modules/security_group"

  project_name = var.project_name
  vpc_id       = module.vpc.vpc_id
  tags         = var.tags
}

module "ec2" {
  source = "./modules/EC2"

  project_name       = var.project_name
  ami_id             = var.ami_id
  instance_type      = var.instance_type
  assign_public_ip   = false
  security_group_ids = [module.security_group.ec2_sg_id] # This line is now valid
  enable_ipv6        = var.enable_ipv6
  user_data          = var.user_data
  tags               = var.tags
}

module "alb" {
  source = "./modules/ALB"

  project_name       = var.project_name
  internal           = false
  vpc_id             = module.vpc.vpc_id
  enable_ipv6        = var.enable_ipv6
  subnet_ids         = module.vpc.public_subnet_ids
  security_group_ids = [module.security_group.alb_sg_id]

  # HTTPS configuration
  enable_https    = var.enable_https
  certificate_arn = var.enable_https ? var.certificate_arn : null

  tags = var.tags
}

module "asg" {
  source = "./modules/ASG" # Make sure this matches your directory name exactly

  project_name       = var.project_name
  desired_capacity   = var.asg_desired_capacity
  max_size           = var.asg_max_size
  min_size           = var.asg_min_size
  subnet_ids         = module.vpc.private_subnet_ids
  target_group_arns  = [module.alb.target_group_arn]
  launch_template_id = module.ec2.launch_template_id
  tags               = var.tags

  # Optional parameters with defaults
  health_check_type         = "ELB"
  health_check_grace_period = 300
  scale_up_cooldown         = 300
  scale_down_cooldown       = 300
}

