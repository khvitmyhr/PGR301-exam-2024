terraform {
  required_version = ">= 1.9"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.74.0"  # Bruker AWS-provider versjon 4.x
    }
  }

  backend "s3" {
    bucket = "pgr301-2024-terraform-state"
    key    = "13.tfstate"
    region = "eu-west-1"
  }
}

provider "aws" {
  region = "eu-west-1"
}