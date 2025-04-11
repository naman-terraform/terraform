# modules/EC2/variables.tf

variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "Instance type for the EC2 instance"
  type        = string
  default     = "t3.micro"
}

variable "assign_public_ip" {
  description = "Whether to assign public IP to the instance"
  type        = bool
  default     = false
}

variable "security_group_ids" {
  description = "List of security group IDs"
  type        = list(string)
}

variable "enable_ipv6" {
  description = "Enable IPv6 support"
  type        = bool
  default     = false
}

variable "user_data" {
  description = "User data script for EC2 instance"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
