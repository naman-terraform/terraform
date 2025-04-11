# modules/ASG/variables.tf

variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "desired_capacity" {
  description = "Desired number of instances in the ASG"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "Maximum number of instances in the ASG"
  type        = number
  default     = 4
}

variable "min_size" {
  description = "Minimum number of instances in the ASG"
  type        = number
  default     = 1
}

variable "target_group_arns" {
  description = "List of target group ARNs for the ASG"
  type        = list(string)
}

variable "subnet_ids" {
  description = "List of subnet IDs for the ASG"
  type        = list(string)
}

variable "launch_template_id" {
  description = "ID of the launch template"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "health_check_grace_period" {
  description = "Time (in seconds) after instance comes into service before checking health"
  type        = number
  default     = 300
}

variable "health_check_type" {
  description = "EC2 or ELB. Controls how health checking is done"
  type        = string
  default     = "ELB"
}

variable "scale_up_cooldown" {
  description = "Cooldown period in seconds for scaling up"
  type        = number
  default     = 300
}

variable "scale_down_cooldown" {
  description = "Cooldown period in seconds for scaling down"
  type        = number
  default     = 300
}
