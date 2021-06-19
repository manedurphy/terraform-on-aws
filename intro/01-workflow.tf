# Terraform Settings Block
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.46.0"
    }
  }
}

# Provider Block
provider "aws" {
  profile = "default" # Configured $HOME/.aws/credentials
  region  = "us-east-1"
}

# Resource Block
resource "aws_instance" "ec2_demo" {
  ami           = "ami-09e67e426f25ce0d7" # Ubuntu 20.04
  instance_type = "t2.micro"

  tags = {
    Name = "ec2-demo"
  }
}
