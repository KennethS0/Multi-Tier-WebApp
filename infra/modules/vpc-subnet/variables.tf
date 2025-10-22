variable "project_prefix" {
    description = "Prefix of the project"
    type = string
}

variable "additional_tags" {
    description = "Additional tags to identify resources"
    type = map(string)
    default = {}
}

variable "vpc_cidr" {
    description = "VPC CIDR"
    type = string
}

variable "pub_subnets" { 
    description = "List of public subnets"
    type = list(string)
}

variable "priv_subnets" {
    description = "List of private subnets"
    type = list(string)
}

variable "azs" { 
    description = "List of availability zones"
    type = list(string)
}