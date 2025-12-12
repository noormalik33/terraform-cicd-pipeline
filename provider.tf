terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Task 7: Remote Backend Configuration
  backend "s3" {
    bucket         = "au-tf-state-noor-2025"  # <--- REPLACE WITH YOUR BUCKET NAME
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}

provider "aws" {
  region = "us-east-1"
}