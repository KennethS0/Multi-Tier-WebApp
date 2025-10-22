resource "aws_instance" "ec2" {
    count = length(var.azs)
    ami = var.ami_id
    instance_type = var.instance_type
    subnet_id = var.subnet_ids[count.index]
    vpc_security_group_ids = var.vpc_security_group_ids
    key_name = var.key_name
    associate_public_ip_address = var.public
    tags = merge(
        var.additional_tags, 
        {
            Name = "${var.project_prefix}-${var.azs[count.index]}-${count.index}",
        }
    )
}