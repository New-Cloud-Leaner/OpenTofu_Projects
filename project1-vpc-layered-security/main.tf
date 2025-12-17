#############################################
# Data sources
#############################################

# No preference , Pick the first AZ
data "aws_availability_zones" "available" {
  state = "available"
}

# Amazon Linux 2023 AMI (latest)
data "aws_ami" "al2023" {
  most_recent      = true
  owners           = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64*"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

#############################################
# 1) VPC
#############################################
resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags{
    Name = var.vpc_name
  }
}

#############################################
# 2) Internet Gateway
#############################################
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = var.igw_name
  }
}

#############################################
# 3) Subnets
#############################################

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnet_cidr
  availability_zone = data.aws_availability_zones.names[0]
  map_public_ip_on_launch = true
  tags = {
    Name = var.public_subnet_name
  }
}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet_name
  availability_zone = data.aws_availability_zones.names[0]
  map_public_ip_on_launch = false
  tags = {
    Name = var.private_subnet_name
  }
}

#############################################
# 4) Route tables
#############################################
# Public route table + default route to IGW
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = var.public_route_table_name
  }
}

resource "aws_route" "public_default" {
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.main.id
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Private Route Table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = var.private_route_table_name
  }
}

resource "aws_route_table_association" "private_assoc" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}

#############################################
# 5) Security group (SSH + ICMP from anywhere)
#############################################

resource "aws_security_group" "main" {
  name        = var.security_group_name
  description = "Allows SSH and ICMP as per lab requirements."
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "allow_SSH_ICMP"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_SSH" {
  security_group_id = aws_security_group.main.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_ICMP" {
  security_group_id = aws_security_group.main.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = "-1" # semantically equivalent to all ports
  ip_protocol       = "icmp"
  to_port           = "-1" # semantically equivalent to all ports
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.main.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

#############################################
# 6) Network ACL + rules + associations
#############################################

