output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = aws_vpc.main.cidr_block
}

output "vpc_ipv6_cidr_block" {
  description = "The IPv6 CIDR block of the VPC"
  value       = aws_vpc.main.ipv6_cidr_block
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = aws_subnet.private[*].id
}

output "public_subnet_cidrs" {
  description = "List of public subnet CIDR blocks"
  value       = aws_subnet.public[*].cidr_block
}

output "private_subnet_cidrs" {
  description = "List of private subnet CIDR blocks"
  value       = aws_subnet.private[*].cidr_block
}

output "public_subnet_ipv6_cidrs" {
  description = "List of public subnet IPv6 CIDR blocks"
  value       = aws_subnet.public[*].ipv6_cidr_block
}

output "private_subnet_ipv6_cidrs" {
  description = "List of private subnet IPv6 CIDR blocks"
  value       = aws_subnet.private[*].ipv6_cidr_block
}

output "nat_gateway_ids" {
  description = "List of NAT Gateway IDs"
  value       = aws_nat_gateway.main[*].id
}

output "nat_gateway_public_ips" {
  description = "List of NAT Gateway public IPs"
  value       = aws_eip.nat[*].public_ip
}

output "egress_only_internet_gateway_id" {
  description = "The ID of the egress-only Internet Gateway"
  value       = aws_egress_only_internet_gateway.main.id
}

output "database_subnet_ids" {
  description = "List of database subnet IDs"
  value       = aws_subnet.database[*].id
}

output "database_subnet_cidrs" {
  description = "List of database subnet CIDR blocks"
  value       = aws_subnet.database[*].cidr_block
}

output "database_route_table_id" {
  description = "ID of database route table"
  value       = aws_route_table.database.id
}

output "flow_log_group_arn" {
  description = "ARN of the Flow Log CloudWatch Log Group"
  value       = var.enable_flow_logs ? aws_cloudwatch_log_group.flow_log[0].arn : null
}

output "flow_log_role_arn" {
  description = "ARN of the Flow Log IAM Role"
  value       = var.enable_flow_logs ? aws_iam_role.flow_log[0].arn : null
}
