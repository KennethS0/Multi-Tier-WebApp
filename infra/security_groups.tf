resource "aws_security_group" "web" {
    name = "${local.name_prefix}-sg-web"
    description = "Web tier SG"
    vpc_id = aws_vpc.main.id

    # Allow access from anywhere on port 80 (Browser)
    ingress { 
        from_port = 80 
        to_port = 80 
        protocol = "tcp" 
        cidr_blocks = ["0.0.0.0/0"] 
    }

    # Allow SSH access from explicit addresses
    dynamic "ingress" {
        for_each = var.ssh_ingress_cidr == null ? {} : { ssh = var.ssh_ingress_cidr }
        content {
            description = "SSH"
            from_port = 22
            to_port = 22
            protocol = "tcp"
            cidr_blocks = [ingress.value]
        }
    }


    egress { 
        from_port = 0 
        to_port = 0 
        protocol = "-1" 
        cidr_blocks = ["0.0.0.0/0"] 
    }

    tags = merge(
        local.tags, 
        { 
            Name = "${local.name_prefix}-sg-web", Tier = "Web"
        }
    )
}


resource "aws_security_group" "app" {
    name = "${local.name_prefix}-sg-app"
    description = "App tier SG"
    vpc_id = aws_vpc.main.id


    ingress {
        description = "App HTTP"
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        security_groups = [aws_security_group.web.id]
    }


    ingress {
        description = "SSH from web"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        security_groups = [aws_security_group.web.id]
    }


    egress { 
        from_port = 0 
        to_port = 0 
        protocol = "-1" 
        cidr_blocks = ["0.0.0.0/0"]
    }


    tags = merge(
        local.tags, 
        { 
            Name = "${local.name_prefix}-sg-app", Tier = "App"
        }
    )
}


resource "aws_security_group" "alb" {
    name = "${local.name_prefix}-sg-alb"
    description = "ALB SG"
    vpc_id = aws_vpc.main.id


    ingress { 
        from_port = 80 
        to_port = 80 
        protocol = "tcp" 
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress { 
        from_port = 0 
        to_port = 0 
        protocol = "-1" 
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = merge(
        local.tags, 
        { 
            Name = "${local.name_prefix}-sg-alb"
        }
    )
}