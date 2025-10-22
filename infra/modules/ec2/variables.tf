variable "project_prefix" {
    description = "Prefix of the project"
    type = string
}

variable "additional_tags" {
    description = "Additional tags to identify resources"
    type = map(string)
    default = {}
}

variable "azs" { 
    description = "List of availability zones"
    type = list(string)
}

variable "key_name" {
    description = "Associated KeyName for Bastion Host access"
    type = string    
}

variable "ami_id" {
    description = "AMI Id used to boot the server"
    type = string
}

variable "public" {
    description = "Server available for public access."
    type = bool
}

variable "instance_type" { 
    type = string
    default = "t3.micro"
}

variable "vpc_security_group_ids" {
    type = list(string)
}


variable "subnet_ids" {
    type = list(string)
}