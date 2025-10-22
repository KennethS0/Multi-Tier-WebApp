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

module "vpc-subnets" {
    source = "./modules/vpc-subnet"
  
    # Required fields for identification of resources
    project_prefix = local.name_prefix
    additional_tags = local.tags

    # CIDRS and subnets
    vpc_cidr = var.vpc_cidr
    pub_subnets = var.pub_subnets
    priv_subnets = var.priv_subnets

    # AZs
    azs = var.azs
}


module "security_groups" {
    source = "./modules/security_groups"

    # Required fields for identification of resources
    project_prefix = local.name_prefix
    additional_tags = local.tags

    # VPC
    vpc_id = module.vpc-subnets.vpc_id

    # SSH Ips for public access
    ssh_ingress_cidr = var.ssh_ingress_cidr
}

module "web_servers" {
    source = "./modules/ec2"

    # Required fields for identification of resources
    project_prefix = "${local.name_prefix}-web"
    additional_tags = merge(
        local.tags,
        {Tier = "Web"}
    )

    # azs
    azs = var.azs

    # Server access
    key_name = var.web_servers_ssh_key_name
    vpc_security_group_ids = [module.security_groups.web_security_group_id]
    subnet_ids = module.vpc-subnets.public_subnet_ids

    # Server config
    ami_id = data.aws_ami.ubuntu.id
    public = true
}

module "app_servers" {
    source = "./modules/ec2"

    # Required fields for identification of resources
    project_prefix = "${local.name_prefix}-app"
    additional_tags = merge(
        local.tags,
        {Tier = "App"}
    )
    
    # azs
    azs = var.azs

    # Server access
    key_name = var.app_servers_ssh_key_name
    vpc_security_group_ids = [module.security_groups.app_security_group_id]
    subnet_ids = module.vpc-subnets.private_subnet_ids

    # Server config
    ami_id = data.aws_ami.ubuntu.id
    public = true
}

module "alb" {
    source = "./modules/alb"

    # Required fields for identification of resources
    project_prefix = local.name_prefix
    additional_tags = local.tags

    # VPC
    vpc_id = module.vpc-subnets.vpc_id

    # Access
    public_subnet_ids = module.vpc-subnets.public_subnet_ids
    alb_security_group_ids = [module.security_groups.alb_security_group_id]
}

# Attach Web Servers to ALB
resource "aws_lb_target_group_attachment" "web" {
    for_each = { for i, inst in module.web_servers.ec2_instances : i => inst }
    target_group_arn = module.alb.aws_lb_target_group_web_arn
    target_id = each.value.id
    port = 80
}