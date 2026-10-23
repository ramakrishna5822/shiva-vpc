resource "aws_subnet" "subnets" {
    vpc_id = aws_vpc.dev.id
    count =3
    cidr_block=element(var.subnet_cidr_blocks, count.index)
    availability_zone = element(var.azs, count.index)
    tags = {
        Name = "${var.vpc_name}-subnet-${count.index + 1}"
    }
}

resource "aws_route_table" "dev" {
    vpc_id = aws_vpc.dev.id
 route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.dev.id
    }
    tags = {
        Name = "${var.vpc_name}-route-table"
    }
}

resource "aws_route_table_association" "subnet_association" {
    count = 3
    subnet_id = element(aws_subnet.subnets.*.id, count.index)
    route_table_id = aws_route_table.dev.id
}