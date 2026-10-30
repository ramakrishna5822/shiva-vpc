resource "aws_eip" "eip" {
    tags = {
        Name = "${var.vpc_name}-eip"
    }
}

resource "aws_nat_gateway" "nat" {
    allocation_id = aws_eip.eip.id
    subnet_id = element(aws_subnet.subnets.*.id, 0)
    tags = {
        Name = "${var.vpc_name}-nat-gateway"
    }
}


resource "aws_route_table" "private" {
    vpc_id = aws_vpc.dev.id
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.nat.id
    }
    tags = {
        Name = "${var.vpc_name}-private-route-table"
    }
}

resource "aws_route_table_association" "private_subnet_association" {
    count = 3
    subnet_id = element(aws_subnet.privatesubnets.*.id, count.index)
    route_table_id = aws_route_table.private.id
}
