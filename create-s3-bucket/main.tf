# Specify the Terraform version
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.5.0"
}

# Configure AWS provider
provider "aws" {
  region = "ap-southeast-1"
}

# Create S3 bucket
resource "aws_s3_bucket" "learning_bucket" {
  bucket = "learning-terraform"

  tags = {
    Environment = "Dev"
    Project     = "Learning Terraform"
  }
}

# Add the bucket policy
resource "aws_s3_bucket_policy" "public_read_policy" {
  bucket = aws_s3_bucket.learning_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "arn:aws:s3:::learning-terraform/*"  # Matches your example
      }
    ]
  })
}

# Enable bucket versioning (optional)
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.learning_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}
