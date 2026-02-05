terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "ap-south-1"
}

#create an s3 bucket
resource "aws_s3_bucket" "my_first_bucket" {
  bucket = "gusainjikibucket"

  tags = {
    Name        = "My bucket v2"
    Environment = "Dev"
  }
}