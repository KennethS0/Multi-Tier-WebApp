output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
    value = [for public_subnet in aws_subnet.public : public_subnet.id]
}

output "private_subnet_ids" {
    value = [for priv_subnet in aws_subnet.private : priv_subnet.id]
}