# DEPENDENCIES aws_subnet.public
# aws_internet_gateway.igw

# aws_subnet.private

resource "aws_eip" "nat" {
    for_each = aws_subnet.public
    domain = "vpc"
    tags = merge(
        local.tags, 
        { 
            Name = "${local.name_prefix}-eip-nat-${each.value.availability_zone}" 
        }
    )
}


resource "aws_nat_gateway" "nat_gateway" {
    for_each = aws_subnet.public
    allocation_id = aws_eip.nat[each.key].id
    subnet_id = each.value.id
    tags = merge(
        local.tags, 
        { 
            Name = "${local.name_prefix}-nat-${each.value.availability_zone}" 
        }
    )
    depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table" "private" {
    for_each = aws_subnet.private
    vpc_id = aws_vpc.main.id
    tags = merge(
        local.tags, 
        { 
            Name = "${local.name_prefix}-private-rt-${each.value.availability_zone}"
        }
    )
}

resource "aws_route" "private_nat" {
    for_each = aws_subnet.private
    route_table_id = aws_route_table.private[each.key].id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway[each.key].id
}

resource "aws_route_table_association" "private_assoc" {
    for_each = aws_subnet.private
    subnet_id = each.value.id
    route_table_id = aws_route_table.private[each.key].id
}
