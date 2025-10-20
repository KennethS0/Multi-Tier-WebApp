resource "aws_lb" "web" {
    name = "${local.name_prefix}-alb"
    internal = false
    load_balancer_type = "application"
    security_groups = [aws_security_group.alb.id]
    subnets = [for s in aws_subnet.public : s.id]
    tags = local.tags
}


resource "aws_lb_target_group" "web" {
    name = "${local.name_prefix}-tg"
    port = 80
    protocol = "HTTP"
    vpc_id = aws_vpc.main.id
    health_check { 
        path = "/" 
        healthy_threshold = 2 
        unhealthy_threshold = 2 
        interval = 15 
        timeout = 5 
        matcher = "200-399" 
    }
}


resource "aws_lb_listener" "http" {
    load_balancer_arn = aws_lb.web.arn
    port = 80
    protocol = "HTTP"
    default_action { 
        type = "forward" 
        target_group_arn = aws_lb_target_group.web.arn
    }
}


resource "aws_lb_target_group_attachment" "web" {
    for_each = { for i, inst in aws_instance.web : i => inst }
    target_group_arn = aws_lb_target_group.web.arn
    target_id = each.value.id
    port = 80
}