resource "aws_lb" "shiva-alb" {
    count = 1
name              = "shiva-alb"
load_balancer_type = "application"
security_groups = [aws_security_group.sg.id]
subnets          = element(aws_subnet.public.*.id, count.index)
internal          = false
tags = {
    Name = "${var.vpc_name}-alb"
}
}

resource "aws_lb_target_group" "shiva-tg" {
  name     = "shiva-tg"
    port     = 80
    protocol = "HTTP"
    vpc_id   = aws_vpc.dev.id
    health_check {
        path                = "/"
        interval            = 30
        timeout             = 5
        healthy_threshold   = 2
        unhealthy_threshold = 2
        matcher             = "200-299"
    }
}

resource "aws_lb_listener" "shiva-listener" {
  load_balancer_arn = aws_lb.shiva-alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.shiva-tg.arn
  }
}

resource "aws_lb_target_group_attachment" "shiva-tg-attachment" {
    count=1
  target_group_arn = aws_lb_target_group.shiva-tg.arn
  target_id        = element(aws_instance.shiva.*.id, 0)
  port             = 80
}