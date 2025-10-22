resource "aws_lb" "web" {
    name = "${var.project_prefix}-alb"
    internal = false
    load_balancer_type = "application"
    security_groups = var.alb_security_group_ids
    subnets = var.public_subnet_ids
    tags = var.additional_tags
}


resource "aws_lb_target_group" "web" {
    name = "${var.project_prefix}-tg"
    port = 80
    protocol = "HTTP"
    vpc_id = var.vpc_id
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