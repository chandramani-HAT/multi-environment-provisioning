output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "internet_gateway_id" {
  description = "Internet Gateway ID"
  value       = module.vpc.internet_gateway_id
}

output "public_subnet_ids" {
  description = "Public Subnet IDs"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Private Subnet IDs"
  value       = module.vpc.private_subnet_ids
}

output "public_route_table_id" {
  description = "Public Route Table ID"
  value       = module.vpc.public_route_table_id
}

output "private_route_table_id" {
  description = "Private Route Table ID"
  value       = module.vpc.private_route_table_id
}

output "ec2_instance_ids" {
  description = "EC2 Instance IDs"
  value       = module.ec2_instances.instance_ids
}
output "ec2_instance_public_ips" {
  description = "Public IPs of EC2 Instances"
  value       = module.ec2_instances.public_ips
}

