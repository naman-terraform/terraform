# modules/vpc/variables.tf

variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
}

variable "enable_nat_gateway" {
  description = "Enable NAT Gateway"
  type        = bool
  default     = true
}

variable "single_nat_gateway" {
  description = "Use a single NAT Gateway for all private subnets"
  type        = bool
  default     = false
}

variable "enable_flow_logs" {
  description = "Enable VPC Flow Logs"
  type        = bool
  default     = false
}

variable "enable_ipv6" {
  description = "Enable IPv6 support"
  type        = bool
  default     = true
}

variable "assign_ipv6_address_on_creation" {
  description = "Assign IPv6 address on subnet creation"
  type        = bool
  default     = true
}

variable "enable_dns_hostnames" {
  description = "Enable DNS hostnames in the VPC"
  type        = bool
  default     = true
}

variable "enable_dns_support" {
  description = "Enable DNS support in the VPC"
  type        = bool
  default     = true
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "flow_log_cloudwatch_log_group_retention_in_days" {
  description = "Number of days to retain flow log records in CloudWatch Logs"
  type        = number
  default     = 7
}

variable "flow_log_cloudwatch_log_group_name_prefix" {
  description = "Prefix for CloudWatch Log Group name for VPC flow logs"
  type        = string
  default     = "/aws/vpc-flow-log/"
}

variable "flow_log_max_aggregation_interval" {
  description = "Maximum aggregation interval for VPC flow logs"
  type        = number
  default     = 600
}

variable "flow_log_traffic_type" {
  description = "Type of traffic to capture in VPC flow logs"
  type        = string
  default     = "ALL"
  validation {
    condition     = contains(["ACCEPT", "REJECT", "ALL"], var.flow_log_traffic_type)
    error_message = "Flow log traffic type must be one of: ACCEPT, REJECT, ALL."
  }
}

variable "create_flow_log_cloudwatch_iam_role" {
  description = "Create IAM role for VPC flow logs"
  type        = bool
  default     = true
}

variable "flow_log_cloudwatch_iam_role_name" {
  description = "Name of the IAM role for VPC flow logs"
  type        = string
  default     = null
}

variable "create_flow_log_cloudwatch_log_group" {
  description = "Create CloudWatch log group for VPC flow logs"
  type        = bool
  default     = true
}

variable "create_egress_only_igw" {
  description = "Create Egress-Only Internet Gateway for IPv6"
  type        = bool
  default     = true
}

variable "database_subnet_cidrs" {
  description = "List of CIDR blocks for database subnets"
  type        = list(string)
}


