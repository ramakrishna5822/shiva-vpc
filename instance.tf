resource "aws_instance" "shiva" {
    count = 2
    ami = var.ami
    instance_type = var.instance_type
    key_name = var.key_name
    vpc_security_group_ids = [aws_security_group.sg.id]
    subnet_id = element(aws_subnet.subnet.*.id, 0)
    associate_public_ip_address = true
    private_ip = element(var.private_ip, count.index)
    user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install apache2 -y
              sudo systemctl start apache2
              sudo systemctl enable apache2
            EOF
    tags = {
        Name = "${var.vpc_name}-instance-${count.index + 1}"

    }
}

resource "aws_instance" "privateserver" {
    count = 1
    ami = var.ami
    instance_type = var.instance_type
    key_name = var.key_name
    vpc_security_group_ids = [aws_security_group.sg.id]
    subnet_id = element(aws_subnet.subnet.*.id, 0)
    associate_public_ip_address = true
    private_ip = element(var.private_ips, count.index)
    user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install apache2 -y
              sudo systemctl start apache2
              sudo systemctl enable apache2
            EOF
    tags = {
        Name = "${var.vpc_name}-instance-${count.index + 1}"

    }
}