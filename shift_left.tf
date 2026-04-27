# Terraform Public Bucket Policy as Code


provider "aws" {
  region = "ap-south-1"
}

# 🔒 Account-level block (strong guardrail)
resource "aws_s3_account_public_access_block" "block_all" {
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# 🪣 Create bucket
resource "aws_s3_bucket" "demo" {
  bucket = "my-terraform-public-test-123456"
}

# 🚫 Try to make it public (this will FAIL)
resource "aws_s3_bucket_acl" "public_acl" {
  bucket = aws_s3_bucket.demo.id
  acl    = "public-read"
}

# 🚫 Try to attach public policy (this will also FAIL)
resource "aws_s3_bucket_policy" "public_policy" {
  bucket = aws_s3_bucket.demo.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = "*"
        Action = "s3:GetObject"
        Resource = "${aws_s3_bucket.demo.arn}/*"
      }
    ]
  })
}
