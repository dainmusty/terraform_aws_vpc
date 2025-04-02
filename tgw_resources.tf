resource "aws_ec2_transit_gateway" "tgw" {
  description = var.tgw_description
  amazon_side_asn = 4200000000
  auto_accept_shared_attachments = "enable"
  default_route_table_association = "disable"
  default_route_table_propagation = "disable"
  dns_support = "enable"
  vpn_ecmp_support = "enable"

  tags = {
    Name = "${var.tgw_resource_prefix}-TransitGateway"
    Environment = var.tgw_resource_prefix
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_attachment" {
  for_each = {for idx, vpc in var.vpc_resource_prefixes : idx => vpc}

  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  vpc_id = aws_vpc.vpc[each.key].id  // Use VPC ID from multi_vpc.tf
  subnet_ids = [aws_subnet.private_subnet[each.key].id]  // Use subnet ID from multi_vpc.tf

  tags = {
    Name = "${var.tgw_resource_prefix}-${each.value}-TGA"
  }
}

resource "aws_ec2_transit_gateway_route_table" "route_table" {
  for_each = {
    "Prod" = "${var.tgw_resource_prefix}-Prod-TGA-RT",
    "NonProd" = "${var.tgw_resource_prefix}-Non-Prod-TGA-RT",
    "Shared" = "${var.tgw_resource_prefix}-Shared-TGA-RT"
  }
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id

  tags = {
    Name = each.value
  }
}

resource "aws_ec2_transit_gateway_route_table_association" "assoc" {
  for_each = {
    "NonProd1" = { tgw_attachment = aws_ec2_transit_gateway_vpc_attachment.tgw_attachment[0].id, rt = aws_ec2_transit_gateway_route_table.route_table["NonProd"].id },
    "NonProd2" = { tgw_attachment = aws_ec2_transit_gateway_vpc_attachment.tgw_attachment[1].id, rt = aws_ec2_transit_gateway_route_table.route_table["NonProd"].id },
    "Prod" = { tgw_attachment = aws_ec2_transit_gateway_vpc_attachment.tgw_attachment[2].id, rt = aws_ec2_transit_gateway_route_table.route_table["Prod"].id },
    "Shared" = { tgw_attachment = aws_ec2_transit_gateway_vpc_attachment.tgw_attachment[3].id, rt = aws_ec2_transit_gateway_route_table.route_table["Shared"].id }
  }
  transit_gateway_attachment_id = each.value.tgw_attachment
  transit_gateway_route_table_id = each.value.rt
}


# Transit Gateway Route Table Propagations
resource "aws_ec2_transit_gateway_route_table_propagation" "propagation" {
  for_each = {
    "Prod1"     = { tgw_attachment = aws_ec2_transit_gateway_vpc_attachment.tgw_attachment[2].id, rt = aws_ec2_transit_gateway_route_table.route_table["Prod"].id },
    "Prod2"     = { tgw_attachment = aws_ec2_transit_gateway_vpc_attachment.tgw_attachment[3].id, rt = aws_ec2_transit_gateway_route_table.route_table["Prod"].id },
    "NonProd1"  = { tgw_attachment = aws_ec2_transit_gateway_vpc_attachment.tgw_attachment[0].id, rt = aws_ec2_transit_gateway_route_table.route_table["NonProd"].id },
    "NonProd2"  = { tgw_attachment = aws_ec2_transit_gateway_vpc_attachment.tgw_attachment[1].id, rt = aws_ec2_transit_gateway_route_table.route_table["NonProd"].id },
    "NonProd3"  = { tgw_attachment = aws_ec2_transit_gateway_vpc_attachment.tgw_attachment[3].id, rt = aws_ec2_transit_gateway_route_table.route_table["NonProd"].id },
    "Shared1"   = { tgw_attachment = aws_ec2_transit_gateway_vpc_attachment.tgw_attachment[0].id, rt = aws_ec2_transit_gateway_route_table.route_table["Shared"].id },
    "Shared2"   = { tgw_attachment = aws_ec2_transit_gateway_vpc_attachment.tgw_attachment[1].id, rt = aws_ec2_transit_gateway_route_table.route_table["Shared"].id },
    "Shared3"   = { tgw_attachment = aws_ec2_transit_gateway_vpc_attachment.tgw_attachment[2].id, rt = aws_ec2_transit_gateway_route_table.route_table["Shared"].id },
    "Shared4"   = { tgw_attachment = aws_ec2_transit_gateway_vpc_attachment.tgw_attachment[3].id, rt = aws_ec2_transit_gateway_route_table.route_table["Shared"].id }
  }

  transit_gateway_attachment_id   = each.value.tgw_attachment
  transit_gateway_route_table_id  = each.value.rt
}

# Blackhole Routes in Prod Transit Gateway Route Table
resource "aws_ec2_transit_gateway_route" "blackhole" {
  for_each = {
    "Blackhole1" = "10.1.0.0/16",
    "Blackhole2" = "10.2.0.0/16"
  }

  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.route_table["Prod"].id
  destination_cidr_block         = each.value
  blackhole                      = true
}

