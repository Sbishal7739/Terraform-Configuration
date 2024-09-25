terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "my-s3-bucket" {
  bucket = "my-s3-bucket123456"
}

resource "aws_s3_object" "my-data" {
  bucket = aws_s3_bucket.my-s3-bucket.bucket
  source = "./testfile.txt"
  key    = "mydata.txt"
}
