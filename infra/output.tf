output "alb_dns_name" { 
    value = module.alb.alb_dns_name 
}
output "web_public_ips" { 
    value = [for i in module.web_servers.ec2_instances : i.public_ip]
}

output "app_private_ips"{ 
    value = [for i in module.app_servers.ec2_instances : i.private_ip]
}

output "vpc_id" { 
    value = module.vpc-subnets.vpc_id
}