# provider.tf

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  
  # IMPORTANT: We are using S3 for state (Phase 3 requirement)
  # Replace "my-terraform-bucket-unique-123" with YOUR ACTUAL BUCKET NAME from Phase 1
  backend "s3" {
    bucket         = "au-tf-state-noor-2025" # <--- UPDATE THIS NAME
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}

provider "aws" {
  region = "us-east-1"
}