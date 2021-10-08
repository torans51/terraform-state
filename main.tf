// Define variables
variable aws_region {
  description = "The aws region to deploy the stack"
}

variable bucket_name {
  description = "The bucket name that will contain terraform states" 
}

variable dynamodb_table {
  description = "The dynamo db table that will contain terraform state locks"
}

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.51.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Name = "Terraform state"
      Provisioner = "Terraform"
    }
  }
}

resource "aws_s3_bucket" "state_bucket" {
  bucket = var.bucket_name
  acl = "private"
  versioning {
    enabled = false
  }
}

resource "aws_dynamodb_table" "state_dynamodb" {
  name = var.dynamodb_table
  hash_key = "LockID"
  read_capacity = 5
  write_capacity = 5

  attribute {
    name = "LockID"
    type = "S"
  }
}
