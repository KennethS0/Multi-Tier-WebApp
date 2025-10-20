variable "aws_region" {
    description = "Instance Creation"
    default = "us-east-2"
}

variable "project" { 
    type = string
    default = "multitier-app"
}

variable "env" {
    type = string
    default = "dev"
}

variable "vpc_cidr" { 
    type = string
    default = "10.0.0.0/16" 
}

variable "azs" { 
    type = list(string)
    default = ["us-east-2a", "us-east-2b"] 
}

variable "pub_subnets" { 
    type = list(string)
    default = ["10.0.10.0/24", "10.0.11.0/24"]
}

variable "pri_subnets" {
    type = list(string)
    default = ["10.0.20.0/24", "10.0.21.0/24"]
}

variable "key_name" { 
    type = string
    default = "BastionHostKey"    
}

variable "instance_type_web" { 
    type = string
    default = "t3.micro"
}

variable "instance_type_app" {
    type = string 
    default = "t3.micro"
}

variable "ssh_ingress_cidr" { 
    type = string 
    default = "0.0.0.0/0"
}