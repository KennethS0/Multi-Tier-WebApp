variable "project_prefix" {
    description = "Prefix of the project"
    type = string
}

variable "additional_tags" {
    description = "Additional tags to identify resources"
    type = map(string)
    default = {}
}

variable "vpc_id" {
  description = "VPC ID"
  type = string
}

variable "ssh_ingress_cidr" {
  description = "Adress where SSH to public servers is allowed"
  type = string
  default = "0.0.0.0/0"
}