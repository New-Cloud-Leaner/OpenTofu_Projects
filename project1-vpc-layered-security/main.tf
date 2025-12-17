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
