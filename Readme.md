# Automate Provisioning and Deployment with Jenkins, Terraform, and Ansible (Multi-Environment)

This repository implements a complete CI/CD pipeline to provision AWS infrastructure using **Terraform**, configure instances and deploy applications using **Ansible**, all orchestrated by **Jenkins**. It supports multiple environments (`dev`, `stage`, `prod`) with isolated Terraform configurations and state management per environment.

---

## Table of Contents

- [Overview](#overview)  
- [Repository Structure](#repository-structure)  
- [Prerequisites](#prerequisites)  
- [Setup Instructions](#setup-instructions)  
  - [1. Jenkins Credentials Setup](#1-jenkins-credentials-setup)  
  - [2. Terraform Infrastructure Provisioning](#2-terraform-infrastructure-provisioning)  
  - [3. Fetch Terraform Outputs](#3-fetch-terraform-outputs)  
  - [4. Generate Ansible Inventory](#4-generate-ansible-inventory)  
  - [5. Establish Passwordless SSH](#5-establish-passwordless-ssh)  
  - [6. AWS CLI Installation on EC2](#6-aws-cli-installation-on-ec2)  
  - [7. Docker Image Deployment](#7-docker-image-deployment)  
- [Jenkins Pipeline](#jenkins-pipeline)  
- [Best Practices](#best-practices)  
- [Troubleshooting](#troubleshooting)  
- [References](#references)  

---

## Overview

- **Terraform** provisions AWS infrastructure including EC2 instances, VPC, subnets, and networking components for each environment (`dev`, `stage`, `prod`).
- Each environment has its own Terraform configuration and backend state file to isolate deployments.
- **Jenkins** orchestrates the pipeline: initializes Terraform, applies infrastructure changes, and triggers Ansible playbooks.
- **Ansible** configures EC2 instances, installs AWS CLI, pulls Docker images, and runs containers.
- SSH keys are securely managed with Jenkins credentials, enabling passwordless SSH between Jenkins and EC2 instances.
- The pipeline handles common issues such as SSH readiness, Python environment restrictions, and AWS CLI installation quirks.

---

## Repository Structure
```
terraform/
├── environments
│   ├── dev/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── backend.tf
│   ├── stage/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── backend.tf
│   └── prod/
│       ├── main.tf
│       ├── variables.tf
│       └── backend.tf
└── modules

ansible/
├── inventory.yaml (dynamically generated)
├── playbooks.yaml
└── roles/

Jenkinsfile
README.md
```

- Each environment folder (`dev`, `stage`, `prod`) contains environment-specific Terraform files.
- `backend.tf` configures remote state backend (e.g., S3 bucket with locking) per environment.
- Variables are defined per environment in `variables.tf` or `.tfvars` files.
- Ansible inventories are generated dynamically from Terraform outputs.
- Jenkinsfile defines the CI/CD pipeline steps.

---

## Prerequisites

- Jenkins server with:
  - Pipeline Utility Steps Plugin (for JSON parsing)
  - SSH Agent Plugin (optional but recommended)
- AWS account with IAM permissions for Terraform and EC2 management
- Terraform installed on Jenkins agents
- Ansible installed on Jenkins agents
- Docker installed on EC2 instances
- PEM private key file for EC2 SSH access

---

## Setup Instructions

### 1. Jenkins Credentials Setup

- Add your PEM private key as a **Secret File** credential in Jenkins (e.g., ID: `terraform_ansible.pem`).
- Add your GitHub token as **Username and Password** credential (e.g., ID: `github-repo`).
- Jenkins `Pipeline Utility Steps` Plugin install on jenkins console.
- These credentials are injected securely into the pipeline.

### 2. Terraform Infrastructure Provisioning

- Navigate to the environment folder (`dev`, `stage`, or `prod`).
- Run Terraform commands via Jenkins pipeline:
  - `terraform init`
  - `terraform plan`
  - `terraform apply`
- Each environment uses its own backend configuration in `backend.tf` to isolate state files.

### 3. Fetch Terraform Outputs

- Use `terraform output -json ec2_instance_public_ips` to extract EC2 public IPs.
- Store the output JSON in an environment variable for use by Ansible.

### 4. Generate Ansible Inventory

- Parse the JSON IP list in Jenkins pipeline using `readJSON`.
- Generate a dynamic Ansible inventory YAML file referencing the PEM key securely.

### 5. Establish Passwordless SSH

- Generate the public key from the PEM file if not already present.
- Wait for SSH service readiness on EC2 instances.
- Use `ssh-copy-id` to copy the public key to EC2 instances for passwordless SSH.
- Retry SSH connection until successful.

### 6. AWS CLI Installation on EC2

- Install `unzip` package first.
- Download AWS CLI v2 installer using `curl`.
- Extract and install using the official bundled installer to avoid Python environment issues.

### 7. Docker Image Deployment

- Define Docker images and container metadata as variables without Jinja2 templating.
- Pull Docker images and run containers conditionally based on inventory hostname.
- Use Ansible `community.docker` modules for idempotent Docker management.

---

## Jenkins Pipeline

- The Jenkinsfile orchestrates the above steps sequentially.
- It securely injects credentials, runs Terraform commands per environment, fetches outputs, generates Ansible inventory, and runs Ansible playbooks.
- Supports multi-branch workflows for different environments.

---

## Best Practices

- Use isolated Terraform backends per environment to avoid state conflicts.
- Manage sensitive keys securely via Jenkins credentials.
- Wait and retry SSH connections before copying keys.
- Use official AWS CLI v2 bundled installer on EC2.
- Avoid Jinja2 templating inside Ansible variables; build commands dynamically.
- Use Ansible modules for Docker to ensure idempotency.
- Organize Ansible playbooks and inventories under a dedicated directory.

---

## Troubleshooting

| Issue                                  | Cause                                         | Solution                                     |
|---------------------------------------|-----------------------------------------------|----------------------------------------------|
| `No such DSL method 'readJSON'`       | Missing Pipeline Utility Steps Plugin          | Install plugin in Jenkins                     |
| PEM file path masked as `****`         | Groovy string interpolation with secrets       | Use single quotes and `$PEM_FILE` in shell   |
| SSH-copy-id fails first run             | SSH service not ready on EC2                    | Add SSH wait/retry loop before copying keys  |
| AWS CLI install errors                  | Python 3.12+ PEP 668 restrictions              | Use official AWS CLI v2 bundled installer     |
| `unzip` command missing                 | `unzip` not installed on EC2                    | Install `unzip` package via apt               |
| Jinja2 templating inside variables      | Ansible does not recursively render variables   | Build commands in tasks, not in variable defs|

---

## References

- [Jenkins Pipeline Utility Steps Plugin](https://plugins.jenkins.io/pipeline-utility-steps/)
- [Ansible Docker Collection](https://docs.ansible.com/ansible/latest/collections/community/docker/docker_container_module.html)
- [AWS CLI Installation Guide](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- [PEP 668 – Python Packaging](https://peps.python.org/pep-0668/)
- [Ansible wait_for Module](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/wait_for_module.html)
- [Terraform Multi-Environment Best Practices](https://dev.to/prakhyatkarri/terraform-45-best-practices-62l)
- [Terraform Multi-Environment Example](https://github.com/DhruvinSoni30/Terraform_Multiple_Environments)

---

## Author

Chandramani

---
