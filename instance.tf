resource "aws_instance" "shiva" {
    count = 1
    ami = var.ami
    instance_type = var.instance_type
    key_name = var.key_name
    vpc_security_group_ids = [aws_security_group.sg.id]
    subnet_id = element(aws_subnet.subnet.*.id, 0)
    associate_public_ip_address = true
    private_ip = var.private_ip
    tags = {
        Name = "${var.vpc_name}-instance"
    }
}