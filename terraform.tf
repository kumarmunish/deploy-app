terraform {
  required_version = "= 1.1.9"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }

  backend "s3" {
    region         = "ap-southeast-2"
    bucket         = "tfstate-bucket"
    key            = "sample-app.tfstate"
    dynamodb_table = "terraform-locks"
    role_arn       = ""
  }

}

# Configure the AWS Provider
provider "aws" {
  region = "ap-southeast-2"
}