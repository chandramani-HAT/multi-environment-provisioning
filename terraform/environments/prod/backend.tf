terraform {
  backend "s3" {
    bucket = "provisioning-prod-tfstate"
    key    = "envs/stage/terraform.tfstate"
    region = "us-east-1"
  }
}
