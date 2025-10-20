# DEPENDENCIES var.pub_subnets, var.azs

resource "aws_vpc" "main" {
    cidr_block = var.vpc_cidr
    enable_dns_hostnames = true
    enable_dns_support = true
    tags = merge(
        local.tags, 
        { 
            Name = "${local.name_prefix}-vpc" 
        }
    )
}


resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.main.id
    tags = merge(
        local.tags, 
        { 
            Name = "${local.name_prefix}-igw" 
        }
    )
}


resource "aws_subnet" "public" {
    for_each = { for idx, cidr in var.pub_subnets : idx => { cidr = cidr, az = var.azs[idx] } }
    vpc_id = aws_vpc.main.id
    cidr_block = each.value.cidr
    availability_zone = each.value.az
    map_public_ip_on_launch = true
    tags = merge(
        local.tags,
        { 
            Name = "${local.name_prefix}-public-${each.value.az}"
            Tier = "Web" 
        }
    )
}


resource "aws_subnet" "private" {
    for_each = { for idx, cidr in var.pri_subnets : idx => { cidr = cidr, az = var.azs[idx] } }
    vpc_id = aws_vpc.main.id
    cidr_block = each.value.cidr
    availability_zone = each.value.az
    tags = merge(
        local.tags, 
        { 
            Name = "${local.name_prefix}-private-${each.value.az}"
            Tier = "App" 
        }
    )
}


resource "aws_route_table" "public" {
    vpc_id = aws_vpc.main.id
    tags = merge(
        local.tags, 
        { 
            Name = "${local.name_prefix}-public-rt"
        }
    )
}


resource "aws_route" "public_inet" {
    route_table_id = aws_route_table.public.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
}


resource "aws_route_table_association" "public_assoc" {
    for_each = aws_subnet.public
    subnet_id = each.value.id
    route_table_id = aws_route_table.public.id
}