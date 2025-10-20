output "alb_dns_name" { value = aws_lb.web.dns_name }
output "web_public_ips" { value = [for i in aws_instance.web : i.public_ip] }
output "app_private_ips"{ value = [for i in aws_instance.app : i.private_ip] }
output "vpc_id" { value = aws_vpc.main.id }