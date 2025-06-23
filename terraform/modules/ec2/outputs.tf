output "public_ips" {
  description = "Public IP addresses of the EC2 instances"
  value       = aws_instance.ec2_instances[*].public_ip
}

output "security_group_id" {
  description = "ID of the EC2 security group"
  value       = aws_security_group.ec2_security_group.id
}

output "instance_ids" {
  description = "IDs of the EC2 instances"
  value       = aws_instance.ec2_instances[*].id
}

output "iam_instance_profile" {
  description = "Name of the IAM instance profile attached to the EC2 instances"
  value = aws_iam_instance_profile.ec2_instance_profile.name
}
