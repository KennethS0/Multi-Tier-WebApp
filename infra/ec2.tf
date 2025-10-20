data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "web" {
    count = length(var.azs)
    ami = data.aws_ami.ubuntu.id
    instance_type = var.instance_type_web
    subnet_id = values(aws_subnet.public)[count.index].id
    vpc_security_group_ids = [aws_security_group.web.id]
    key_name = var.key_name
    associate_public_ip_address = true
    tags = merge(
        local.tags, 
        {
            Name = "${local.name_prefix}-web-${var.azs[count.index]}-${count.index}",
            Tier = "Web",
            Role = "web-server"
        }
    )
}


resource "aws_instance" "app" {
    count = length(var.azs)
    ami = data.aws_ami.ubuntu.id
    instance_type = var.instance_type_app
    subnet_id = values(aws_subnet.private)[count.index].id
    vpc_security_group_ids = [aws_security_group.app.id]
    key_name = var.key_name
    associate_public_ip_address = false
    tags = merge(
        local.tags, 
        {
            Name = "${local.name_prefix}-app-${var.azs[count.index]}-${count.index}",
            Tier = "App",
            Role = "app-server"
        }
    )
}