resource "aws_vpc" "vpc" {
  count                = length(var.vpc_cidr_blocks)
  cidr_block           = var.vpc_cidr_blocks[count.index]
  enable_dns_support   = true
  enable_dns_hostnames = true
  
  tags = {
    Name = "${var.vpc_resource_prefixes[count.index]}-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  count = length(var.vpc_cidr_blocks)
  vpc_id = aws_vpc.vpc[count.index].id
  
  tags = {
    Name = "${var.vpc_resource_prefixes[count.index]}-igw"
  }
}

resource "aws_subnet" "public_subnet" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.vpc[count.index].id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true
  
  tags = {
    Name = "${var.vpc_resource_prefixes[count.index]}-publicsubnet"
  }
}

resource "aws_subnet" "private_subnet" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.vpc[count.index].id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]
  
  tags = {
    Name = "${var.vpc_resource_prefixes[count.index]}-privatesubnet"
  }
}

resource "aws_route_table" "public_route_table" {
  count  = length(var.vpc_cidr_blocks)
  vpc_id = aws_vpc.vpc[count.index].id
  
  tags = {
    Name = "${var.vpc_resource_prefixes[count.index]}-publicroutetable"
  }
}

resource "aws_route" "public_route" {
  count = length(var.vpc_cidr_blocks)
  route_table_id         = aws_route_table.public_route_table[count.index].id
  destination_cidr_block = var.PR_destination_cidr_block  // Use variable for destination CIDR block
  gateway_id             = aws_internet_gateway.igw[count.index].id
}

resource "aws_route_table_association" "public_subnet_association" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_route_table[count.index].id
}

resource "aws_route_table" "private_route_table" {
  count  = length(var.vpc_cidr_blocks)
  vpc_id = aws_vpc.vpc[count.index].id
  
  tags = {
    Name = "${var.vpc_resource_prefixes[count.index]}-privateroutetable"
  }
}

resource "aws_route_table_association" "private_subnet_association" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_route_table[count.index].id
}
