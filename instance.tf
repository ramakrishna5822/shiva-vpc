resource "aws_instance" "shiva" {
    ami = var.ami
    instance_type = var.instance_type
    key_name = var.key_name
    vpc_security_group_ids = [aws_security_group.sg.id]
    associate_public_ip_address = true
    private_ip = var.private_ip
    tags = {
        Name = "${var.vpc_name}-instance"
    }
}