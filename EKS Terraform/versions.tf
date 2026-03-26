terraform {
  required_version = ">= 1.14.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
  # Store state remotely so your team shares the same state
  # Create this S3 bucket manually ONCE before running terraform init
  backend "s3" {
    bucket = "my-company-terraform-state"
    key    = "eks/production/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}