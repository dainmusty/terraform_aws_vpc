# General variables for all modules

variable "ResourcePrefix" {
  description = "Prefix for resource names"
  type        = string
}

# standard variables for tgw module

variable "vpc_cidr_blocks" {
  description = "List of CIDR blocks for the VPCs"
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

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}

variable "tgw_resource_prefix" {
  description = "Prefix for Transit Gateway resources"
  type        = string
}

variable "vpc_resource_prefixes" {
  description = "List of prefixes for VPC resources"
  type        = list(string)
}

variable "tgw_description" {
  description = "Description for the Transit Gateway"
  type        = string
}

variable "PR_destination_cidr_block" {
  description = "The CIDR block for the destination route"
  type        = string
}

