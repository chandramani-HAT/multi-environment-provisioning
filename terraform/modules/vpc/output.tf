output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.vpc.id
}

output "internet_gateway_id" {
  description = "Internet Gateway ID"
  value       = aws_internet_gateway.internet_gateway.id
}

output "public_subnet_ids" {
  description = "Public Subnet IDs"
  value       = aws_subnet.public_subnets[*].id
}

output "private_subnet_ids" {
  description = "Private Subnet IDs"
  value       = aws_subnet.private_subnets[*].id
}

output "public_route_table_id" {
  description = "Public Route Table ID"
  value       = aws_route_table.public_route_table.id
}

output "private_route_table_id" {
  description = "Private Route Table ID"
  value       = aws_route_table.private_route_table.id
}
