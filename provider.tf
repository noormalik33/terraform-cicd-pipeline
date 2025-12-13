# provider.tf

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # ✅ Remote Backend Configuration (S3 + DynamoDB for state locking)
  backend "s3" {
    bucket         = "au-tf-state-noor-2025"  # <-- Your S3 bucket
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}

provider "aws" {
  region = "us-east-1"
}
