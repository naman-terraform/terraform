project_name                    = "iscara"
environment                     = "Production" # Add this line
aws_region                      = "us-east-1"
vpc_cidr                        = "10.0.0.0/16"
az_count                        = 2
subnet_bits                     = 8
enable_nat_gateway              = true
enable_flow_logs                = true
enable_ipv6                     = true
assign_ipv6_address_on_creation = true
single_nat_gateway              = false

instance_type = "t3.micro"
enable_https = false
ami_id = "ami-xxxxxxxx"  # You'll input this during plan
asg_desired_capacity = 2
asg_max_size = 4
asg_min_size = 1

tags = {
  Environment = "Production"
  Terraform   = "true"
  Project     = "ISCARA"
}
