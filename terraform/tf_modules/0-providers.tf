terraform {
  backend "s3" {}
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
      Modules     = true
      Purpose     = "Demo EKS by Terraform Modules"
    }
  }
}