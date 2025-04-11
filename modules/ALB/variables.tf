# modules/ALB/variables.tf

variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "internal" {
  description = "Whether the ALB is internal"
  type        = bool
  default     = false
}

variable "security_group_ids" {
  description = "List of security group IDs for the ALB"
  type        = list(string)
}

variable "subnet_ids" {
  description = "List of subnet IDs for the ALB"
  type        = list(string)
}

variable "enable_ipv6" {
  description = "Enable IPv6 support"
  type        = bool
  default     = false
}

variable "enable_deletion_protection" {
  description = "Enable deletion protection for the ALB"
  type        = bool
  default     = false
}

variable "certificate_arn" {
  description = "Enter the ARN of the SSL certificate for HTTPS listener (leave empty if HTTPS is not enabled)"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "enable_https" {
  description = "Do you want to enable HTTPS listener with SSL/TLS termination? (true/false)"
  type        = bool
  default     = false
}