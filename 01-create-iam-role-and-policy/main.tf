provider "aws" {
  region = "ap-southeast-1"
}

resource "aws_iam_policy" "example_iam_policy" {
  name        = "ExampleIAMPolicy"
  description = "IAM policy to allow S3 access"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
          "s3:GetObject"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role" "example_iam_role" {
  name = "ExampleIAMRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "example_attachment" {
  role       = aws_iam_role.example_iam_role.name
  policy_arn = aws_iam_policy.example_iam_policy.arn
}
