provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source               = "../../modules/vpc"
  vpc_cidr             = var.vpc_cidr
  vpc_name             = var.vpc_name
  environment          = var.environment
  owner                = var.owner
  project              = var.project
  classification       = var.classification
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
  tags                 = var.tags
}

module "ec2_instances" {
  source         = "../../modules/ec2"
  ami_id         = var.ami_id
  instance_type  = var.instance_type
  key_name       = var.key_name
  vpc_id         = module.vpc.vpc_id
  subnet_ids     = module.vpc.public_subnet_ids
  instance_count = var.instance_count
  environment    = var.environment
  owner          = var.owner
  project        = var.project
  classification = var.classification
  tags           = var.tags
}
