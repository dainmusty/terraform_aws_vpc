
# General variables for all modules

variable "ResourcePrefix" {
  description = "Prefix for resource names"
  type        = string
}

# standard variables for tgw module

variable "vpc_cidr_blocks" {
  description = "List of CIDR blocks for the VPCs"
  type        = list(string)
  default     = ["10.1.0.0/16", "10.2.0.0/16", "10.3.0.0/16", "10.4.0.0/16"]
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.1.1.0/24", "10.2.1.0/24", "10.3.1.0/24", "10.4.1.0/24"]
}

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.1.2.0/24", "10.2.2.0/24", "10.3.2.0/24", "10.4.2.0/24"]
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1a", "us-east-1b"]
}

variable "tgw_resource_prefix" {
  description = "Prefix for Transit Gateway resources"
  type        = string
  default     = "Effulgentech"
}

variable "vpc_resource_prefixes" {
  description = "List of prefixes for VPC resources"
  type        = list(string)
  default     = ["Dev", "Stage", "Prod", "Shared"]
}

variable "tgw_description" {
  description = "Description for the Transit Gateway"
  type        = string
  default     = "Effulgencetech Transit Gateway to connect Dev, Stage, Prod, and Shared VPCs"
}

variable "PR_destination_cidr_block" {
  description = "The CIDR block for the destination route"
  type        = string
  default     = "0.0.0.0/0"
}

