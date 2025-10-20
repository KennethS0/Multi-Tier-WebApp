terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket = "ksanchez-my-terraformworkshop"
    key = "terraform.tfstate"
    region = "us-east-2"
    # Without the following no backend locking will be created
    dynamodb_table = "my-table-dynamodb"
    encrypt=true
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = var.aws_region
}