resource "aws_lb" "shiva-nlb" {
    name             = "shiva-nlb"
    load_balancer_type = "network"
    subnets          = aws_subnet.public.*.id
    internal         = false
    tags = {
        Name = "${var.vpc_name}-nlb"
    }
}

resource "aws_lb_target_group" "shiva-nlb-tg" {
    name = "shiva-nlb-tg"
    port = 8080
    protocol = "TCP"
    vpc_id = aws_vpc.dev.id
    health_check {
        port                = "traffic-port"
        protocol            = "TCP"
        interval            = 30
        timeout             = 5
        healthy_threshold   = 2
        unhealthy_threshold = 2
    }
}

resource "aws_lb_listener" "shiva-nlb-listener" {
    load_balancer_arn = aws_lb.shiva-nlb.arn
    port              = 80
    protocol          = "TCP"

    default_action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.shiva-nlb-tg.arn
    }
}

resource "aws_lb_target_group_attachment" "shiva-nlb-tg-attachment" {
    target_group_arn = aws_lb_target_group.shiva-nlb-tg.arn
    target_id        = aws_instance.shiva.0.id
    port             = 8080
}