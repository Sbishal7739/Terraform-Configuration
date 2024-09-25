terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.6.3"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

resource "random_id" "server" {
  byte_length = 8
}

resource "aws_s3_bucket" "my-webapp-bucket" {
  bucket = "my-webapp-s3-${random_id.server.hex}"
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.my-webapp-bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  bucket = aws_s3_bucket.my-webapp-bucket.id
  policy = jsonencode(
    {
      Version = "2012-10-17",
      Statement = [
        {
          Sid       = "PublicReadGetObject",
          Effect    = "Allow",
          Principal = "*",
          Action = [
            "s3:GetObject"
          ],
          Resource = [
            "arn:aws:s3:::${aws_s3_bucket.my-webapp-bucket.id}/*"
          ]
        }
      ]
    }
  )
}

resource "aws_s3_bucket_website_configuration" "my-webapp-bucket" {
  bucket = aws_s3_bucket.my-webapp-bucket.id

  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_object" "index_html" {
  bucket       = aws_s3_bucket.my-webapp-bucket.bucket
  source       = "./index.html"
  key          = "index.html"
  content_type = "text/html"
}
output "bucket_name" {
  value = aws_s3_bucket.my-webapp-bucket.bucket
}

output "  name" {
  value = aws_s3_bucket_website_configuration.my-webapp-bucket.website_endpoint
}
