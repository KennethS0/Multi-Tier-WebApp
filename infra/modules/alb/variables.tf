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

variable "alb_security_group_ids" {
    description = "Security group IDs to control traffic into ALB"
    type = list(string)
}

variable "public_subnet_ids" {
    description = "List of public subnet ids"
    type = list(string)
} 