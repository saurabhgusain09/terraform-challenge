terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.31.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

#variables
variable "env" {
  default = "dev"
}

#locals
locals {
  naming= var.env
}

#output variables
output "vpc_id" {
  value = aws_vpc.myvpc.id
}
output "instance_ip" {
  value = aws_instance.myinstance.public_ip
}

#creation of s3 bucket
resource "aws_s3_bucket" "mybucket" {
  bucket = "gusainjikibucket${local.naming}"
    tags = {
        Name        = "My bucket v2"
        Environment = var.env
    }
}

#creation of vpc 

resource "aws_vpc" "myvpc" {
  cidr_block = "192.168.0.0/24"
    tags = {
        Name = "myvpc"
        Environment = var.env
    }
}


#creation of ec2 instance

resource "aws_instance" "myinstance" {
  ami = "ami-0ff5003538b60d5ec"
    instance_type = "t2.micro"

    tags = {
      Name = "FirstInstance"
      Environment = var.env
    }
}