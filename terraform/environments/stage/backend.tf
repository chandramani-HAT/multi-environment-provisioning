terraform {
  backend "s3" {
    bucket = "provisioning-prod-tfstate"
    key    = "envs/prod/terraform.tfstate"
    region = "us-east-1"
  }
}
