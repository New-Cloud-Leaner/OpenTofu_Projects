variable "region" {
  description = "AWS region for this lab"
  default     = "ap-south-1"
  type        = string
}
variable "vpc_name" {
  description = "VPC name tag"
  type        = string
  default     = "main_vpc"
}
variable "igw_name" {
  description = "Internet Gateway name tag"
  type        = string
  default     = "main_igw"
}
variable "public_subnet_name" {
  description = "Public Subnet name tag"
  type        = string
  default     = "public_subnet"
}
variable "private_subnet_name" {
  description = "Private Subnet name tag"
  type        = string
  default     = "private_subnet"
}

variable "public_route_table_name" {
  description = "Public route table name tag"
  type        = string
  default     = "public_route_table"
}
variable "private_route_table_name" {
  description = "Private route table name tag"
  type        = string
  default     = "private_route_table"
}

variable "security_group_name" {
  description = "Security group name"
  type        = string
  default     = "main_security_group"
}

variable "nacl_name" {
  description = "Network ACL Name tag"
  type        = string
  default     = "main_nacl"
}

variable "key_name" {
  description = "EC2 Key Pair Name"
  type        = string
  default     = "ProjectKey"
}

variable "vpc_cidr" {
  description = "VPC IPv4 CIDR"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "Public subnet IPv4 CIDR"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "Private subnet IPv4 CIDR"
  type        = string
  default     = "10.0.2.0/24"
}

