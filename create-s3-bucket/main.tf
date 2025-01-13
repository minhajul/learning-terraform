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

# Generate a random suffix for a globally unique bucket name
resource "random_string" "suffix" {
  length  = 6
  upper   = false
  special = false
}

# Create S3 bucket
resource "aws_s3_bucket" "learning_bucket" {
  bucket = "learning-terraform-${random_string.suffix.result}"

  tags = {
    Environment = "Dev"
    Project     = "Learning Terraform"
  }
}

resource "aws_s3_bucket_acl" "learning_bucket" {
  bucket = aws_s3_bucket.learning_bucket.id
  acl = "public-read"
}

# Disable Block Public Access for the bucket
resource "aws_s3_bucket_public_access_block" "allow_public_acl" {
  bucket = aws_s3_bucket.learning_bucket.id

  block_public_acls       = false   # Allow public ACLs
  block_public_policy     = true    # Keep blocking public bucket policies
  ignore_public_acls      = false   # Don't ignore public ACLs
  restrict_public_buckets = true    # Restrict public buckets based on ACLs
}


# Add the bucket policy
resource "aws_s3_bucket_policy" "public_read_policy" {
  bucket = aws_s3_bucket.learning_bucket.id

  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.learning_bucket.arn}/*"
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
