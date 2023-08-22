terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-east-2"
}

resource "aws_s3_bucket" "strapi_storage" {
  bucket = "my-s3-strapi-bucket"
  tags = {
    Name       = "Strapi Bucket"
    Enviroment = "Dev"
  }
}

resource "aws_s3_bucket_ownership_controls" "s3_controls" {
  bucket = aws_s3_bucket.strapi_storage.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "s3_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.s3_controls]
  bucket     = aws_s3_bucket.strapi_storage.id
  acl        = "public-read"
}

resource "aws_s3_bucket_public_access_block" "s3_access" {
  bucket                  = aws_s3_bucket.strapi_storage.id
  block_public_acls       = false
  ignore_public_acls      = false
  block_public_policy     = true
  restrict_public_buckets = true
}

output "s3" {
  value = aws_s3_bucket.strapi_storage.bucket_domain_name
}
