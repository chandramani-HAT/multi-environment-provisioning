terraform {
  backend "s3" {
    bucket = "provisioning-prod-tfstate"
    key    = "envs/dev/terraform.tfstate"
    region = "us-east-1"
  }
}
