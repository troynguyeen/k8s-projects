terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.93.0"
    }
  }
}

provider "aws" {
  region = var.region
  default_tags {
    tags = {
      Environment = "dev"
      Terraform   = true
      Purpose     = "Demo EKS by Terraform"
    }
  }
}