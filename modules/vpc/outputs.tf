output "subnet_ids" {
  description = "List Ids of subnet"
  value       = aws_subnet.public_subnet.*.id
}

output "vpc_id" {
  description = "The VPC id"
  value       = aws_vpc.main.id
}

output "vpc_cidr_blocks" {
  description = "The VPC cidr block"
  value       = aws_vpc.main.cidr_block
}
