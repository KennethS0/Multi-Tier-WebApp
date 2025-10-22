output "alb_dns_name" {
    value = aws_lb.web.dns_name
}

output "aws_lb_target_group_web_arn" {
    value = aws_lb_target_group.web.arn
}