variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_name" {
  description = "Name tag for the VPC"
  type        = string
  default     = "production-vpc"
}

variable "environment" {
  description = "Environment tag (prod, staging, dev)"
  type        = string
  default     = "prod"
}

variable "owner" {
  description = "Owner tag"
  type        = string
  default     = "DevOps Team"
}

variable "project" {
  description = "Project tag"
  type        = string
  default     = "Automation Project"
}

variable "classification" {
  description = "Classification tag"
  type        = string
  default     = "confidential"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

variable "availability_zones" {
  description = "Availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default = {
    "Terraform" = "true"
  }
}

variable "ami_id" {
  description = "AMI ID for EC2 instances"
  type        = string
  default     = "ami-020cba7c55df1f615"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.medium"
}

variable "key_name" {
  description = "Key pair name for SSH access"
  type        = string
  default = "terraform_ansible"
}

variable "instance_count" {
  description = "Number of EC2 instances to launch"
  type        = number
  default     = 2
  
}