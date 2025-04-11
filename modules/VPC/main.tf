# Create VPC
resource "aws_vpc" "main" {
  cidr_block                       = var.vpc_cidr
  enable_dns_hostnames             = true
  enable_dns_support               = true
  assign_generated_ipv6_cidr_block = var.enable_ipv6 # Enable IPv6 CIDR block

  tags = merge(
    {
      Name = "${var.project_name}-vpc"
    },
    var.tags
  )
}

# Create Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    {
      Name = "${var.project_name}-igw"
    },
    var.tags
  )
}

# Create Egress-Only Internet Gateway for IPv6
resource "aws_egress_only_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    {
      Name = "${var.project_name}-eigw"
    },
    var.tags
  )
}

# Create Public Subnets
resource "aws_subnet" "public" {
  count                                          = length(var.public_subnet_cidrs)
  vpc_id                                         = aws_vpc.main.id
  cidr_block                                     = var.public_subnet_cidrs[count.index]
  availability_zone                              = var.availability_zones[count.index]
  map_public_ip_on_launch                        = true
  assign_ipv6_address_on_creation                = var.assign_ipv6_address_on_creation
  enable_resource_name_dns_aaaa_record_on_launch = true

  # Calculate IPv6 CIDR block for public subnets
  ipv6_cidr_block = cidrsubnet(aws_vpc.main.ipv6_cidr_block, 8, count.index)

  tags = merge(
    {
      Name                     = "${var.project_name}-public-subnet-${count.index + 1}"
      "kubernetes.io/role/elb" = "1"
    },
    var.tags
  )
}

# Create Private Subnets
resource "aws_subnet" "private" {
  count                                          = length(var.private_subnet_cidrs)
  vpc_id                                         = aws_vpc.main.id
  cidr_block                                     = var.private_subnet_cidrs[count.index]
  availability_zone                              = var.availability_zones[count.index]
  assign_ipv6_address_on_creation                = true
  enable_resource_name_dns_aaaa_record_on_launch = true

  # Calculate IPv6 CIDR block for private subnets
  ipv6_cidr_block = cidrsubnet(aws_vpc.main.ipv6_cidr_block, 8, count.index + length(var.public_subnet_cidrs))

  tags = merge(
    {
      Name                              = "${var.project_name}-private-subnet-${count.index + 1}"
      "kubernetes.io/role/internal-elb" = "1"
    },
    var.tags
  )
}

# Create Database Subnets
resource "aws_subnet" "database" {
  count                           = length(var.database_subnet_cidrs)
  vpc_id                          = aws_vpc.main.id
  cidr_block                      = var.database_subnet_cidrs[count.index]
  availability_zone               = var.availability_zones[count.index]
  assign_ipv6_address_on_creation = var.assign_ipv6_address_on_creation

  # IPv6 configuration
  ipv6_cidr_block                                = cidrsubnet(aws_vpc.main.ipv6_cidr_block, 8, count.index + length(var.public_subnet_cidrs) + length(var.private_subnet_cidrs))
  enable_resource_name_dns_aaaa_record_on_launch = true

  tags = merge(
    {
      Name = "${var.project_name}-database-subnet-${count.index + 1}"
      Tier = "Database"
    },
    var.tags
  )
}

# Create Database Route Table
resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    {
      Name = "${var.project_name}-database-rt"
    },
    var.tags
  )
}

# Database Route Table Association
resource "aws_route_table_association" "database" {
  count          = length(var.database_subnet_cidrs)
  subnet_id      = aws_subnet.database[count.index].id
  route_table_id = aws_route_table.database.id
}


# Create NAT Gateway (if enabled)
resource "aws_eip" "nat" {
  count  = var.enable_nat_gateway ? length(var.public_subnet_cidrs) : 0
  domain = "vpc"

  tags = merge(
    {
      Name = "${var.project_name}-nat-eip-${count.index + 1}"
    },
    var.tags
  )
}

resource "aws_nat_gateway" "main" {
  count         = var.enable_nat_gateway ? length(var.public_subnet_cidrs) : 0
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  depends_on = [aws_internet_gateway.main]

  tags = merge(
    {
      Name = "${var.project_name}-nat-${count.index + 1}"
    },
    var.tags
  )
}

# Route Tables and Associations
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  # IPv4 route to Internet Gateway
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  # IPv6 route to Internet Gateway
  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.main.id
  }

  tags = merge(
    {
      Name = "${var.project_name}-public-rt"
    },
    var.tags
  )
}

resource "aws_route_table" "private" {
  count  = length(var.private_subnet_cidrs)
  vpc_id = aws_vpc.main.id

  # IPv4 route to NAT Gateway (if enabled)
  dynamic "route" {
    for_each = var.enable_nat_gateway ? [1] : []
    content {
      cidr_block     = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.main[count.index].id
    }
  }

  # IPv6 route to Egress-Only Internet Gateway
  route {
    ipv6_cidr_block        = "::/0"
    egress_only_gateway_id = aws_egress_only_internet_gateway.main.id
  }

  tags = merge(
    {
      Name = "${var.project_name}-private-rt-${count.index + 1}"
    },
    var.tags
  )
}

# Route Table Associations for Public Subnets
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Route Table Associations for Private Subnets
resource "aws_route_table_association" "private" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}


# Network ACL for IPv6
resource "aws_network_acl" "main" {
  vpc_id = aws_vpc.main.id
  subnet_ids = concat(
    aws_subnet.public[*].id,
    aws_subnet.private[*].id
  )

  # Allow all IPv4 traffic
  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  # Allow all IPv6 traffic
  ingress {
    protocol        = -1
    rule_no         = 101
    action          = "allow"
    ipv6_cidr_block = "::/0"
    from_port       = 0
    to_port         = 0
  }

  egress {
    protocol        = -1
    rule_no         = 101
    action          = "allow"
    ipv6_cidr_block = "::/0"
    from_port       = 0
    to_port         = 0
  }

  tags = merge(
    {
      Name = "${var.project_name}-nacl"
    },
    var.tags
  )
}

# CloudWatch Log Group for VPC Flow Logs
resource "aws_cloudwatch_log_group" "flow_log" {
  count             = var.enable_flow_logs ? 1 : 0
  name              = "/aws/vpc-flow-log/${var.project_name}"
  retention_in_days = 30

  tags = merge(
    {
      Name = "${var.project_name}-flow-log-group"
    },
    var.tags
  )
}

# IAM Role for VPC Flow Logs
resource "aws_iam_role" "flow_log" {
  count = var.enable_flow_logs ? 1 : 0
  name  = "${var.project_name}-flow-log-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "vpc-flow-logs.amazonaws.com"
        }
      }
    ]
  })

  tags = merge(
    {
      Name = "${var.project_name}-flow-log-role"
    },
    var.tags
  )
}

# IAM Role Policy for VPC Flow Logs
resource "aws_iam_role_policy" "flow_log" {
  count = var.enable_flow_logs ? 1 : 0
  name  = "${var.project_name}-flow-log-policy"
  role  = aws_iam_role.flow_log[0].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams"
        ]
        Effect = "Allow"
        Resource = [
          "${aws_cloudwatch_log_group.flow_log[0].arn}",
          "${aws_cloudwatch_log_group.flow_log[0].arn}:*"
        ]
      }
    ]
  })
}

# VPC Flow Log
resource "aws_flow_log" "main" {
  count                = var.enable_flow_logs ? 1 : 0
  vpc_id               = aws_vpc.main.id
  traffic_type         = "ALL"
  iam_role_arn         = aws_iam_role.flow_log[0].arn
  log_destination      = aws_cloudwatch_log_group.flow_log[0].arn
  log_destination_type = "cloud-watch-logs"

  tags = merge(
    {
      Name = "${var.project_name}-flow-log"
    },
    var.tags
  )
}

