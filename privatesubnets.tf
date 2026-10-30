resource "aws_subnet" "privatesubnets" {
    vpc_id = aws_vpc.dev.id
    count = 3
    cidr_block = element(var.privatesubnet_cidr_blocks, count.index)
    availability_zone = element(var.azs, count.index)
    tags = {
        Name = "${var.vpc_name}-private-subnet-${count.index + 1}"
    }
}

