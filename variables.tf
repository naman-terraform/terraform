variable "aws_profile" {
  description = "AWS profile to use"
  type        = string
  default     = "default"
}

variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}

variable "az_count" {
  description = "Number of AZs to use"
  type        = number
  default     = 2
}

variable "subnet_bits" {
  description = "Number of bits for subnet CIDR calculation"
  type        = number
  default     = 8
}

variable "enable_nat_gateway" {
  description = "Enable NAT Gateway"
  type        = bool
  default     = true
}

variable "enable_flow_logs" {
  description = "Enable VPC Flow Logs"
  type        = bool
  default     = false
}

variable "enable_ipv6" {
  description = "Enable IPv6 in VPC"
  type        = bool
  default     = true
}

variable "assign_ipv6_address_on_creation" {
  description = "Assign IPv6 address on subnet creation"
  type        = bool
  default     = true
}

variable "single_nat_gateway" {
  description = "Use a single NAT Gateway for all private subnets"
  type        = bool
  default     = false
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "ami_id" {
  description = "AMI ID for EC2 instances"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "asg_desired_capacity" {
  description = "Desired capacity for ASG"
  type        = number
  default     = 2
}

variable "asg_max_size" {
  description = "Maximum size for ASG"
  type        = number
  default     = 4
}

variable "asg_min_size" {
  description = "Minimum size for ASG"
  type        = number
  default     = 1
}

variable "certificate_arn" {
  description = "ARN of ACM certificate for ALB"
  type        = string
  default     = null
}

variable "user_data" {
  type    = string
  default = ""
}

variable "enable_https" {
  description = "Enable HTTPS listener with SSL/TLS termination"
  type        = bool
  default     = false
}
