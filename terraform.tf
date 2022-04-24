terraform {
  required_version = "= 1.1.9"

# comment this code and run terraform plan/apply and then do terraform init again to use this backend 
  backend "s3" {
    bucket = "tfstate-bucket-{unique-identifier}"
    key    = "terraform.tfstate"
    region = "ap-southeast-2"
    aws_dynamodb_table = "terraform_state_locking"
    encrypt = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "ap-southeast-2"
}