output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "vpc_cidr" {
  description = "The CIDR block of the VPC"
  value       = module.vpc.vpc_cidr_block
}

output "vpc_ipv6_cidr" {
  description = "The IPv6 CIDR block of the VPC"
  value       = module.vpc.vpc_ipv6_cidr_block
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = module.vpc.private_subnet_ids
}

output "public_subnet_cidrs" {
  description = "List of public subnet CIDR blocks"
  value       = module.vpc.public_subnet_cidrs
}

output "private_subnet_cidrs" {
  description = "List of private subnet CIDR blocks"
  value       = module.vpc.private_subnet_cidrs
}

output "public_subnet_ipv6_cidrs" {
  description = "List of public subnet IPv6 CIDR blocks"
  value       = module.vpc.public_subnet_ipv6_cidrs
}

output "private_subnet_ipv6_cidrs" {
  description = "List of private subnet IPv6 CIDR blocks"
  value       = module.vpc.private_subnet_ipv6_cidrs
}

output "nat_gateway_ids" {
  description = "List of NAT Gateway IDs"
  value       = module.vpc.nat_gateway_ids
}

output "egress_only_internet_gateway_id" {
  description = "The ID of the egress-only Internet Gateway"
  value       = module.vpc.egress_only_internet_gateway_id
}
