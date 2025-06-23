# ec2_setup Role

This Ansible role performs the following tasks on EC2 instances:

- Installs Docker and AWS CLI
- Logs into AWS ECR
- Pulls Docker images from ECR
- Runs Docker containers:
  - Runs `image1` on the first EC2 instance
  - Runs `image2` on the second EC2 instance

## Variables

- `docker_images`: List of images and run commands (default in `defaults/main.yml`)
- `aws_region`: AWS region for ECR login (default in `vars/main.yml`)

## Usage

Include this role in your playbook and provide the inventory with EC2 public IPs.

Ensure the EC2 instances have IAM roles with permissions to pull from ECR.
