terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Provider (in main.tf, not separate file)
provider "aws" {
  region = var.aws_region
}

# S3 bucket for static website
resource "aws_s3_bucket" "website" {
  bucket = var.bucket_name

  tags = {
    Name = "Simple Terraform Website"
  }
}

# Enable static website hosting
resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.website.id

  index_document {
    suffix = "index.html"
  }
}

# Allow public access settings
resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.website.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Bucket policy for public read access
resource "aws_s3_bucket_policy" "public_policy" {
  bucket = aws_s3_bucket.website.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "PublicRead",
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource  = "${aws_s3_bucket.website.arn}/*"
      }
    ]
  })
}

# Upload index.html object
resource "aws_s3_object" "index_file" {
  bucket = aws_s3_bucket.website.id
  key    = "index.html"

  content = <<EOF
<h1 style="color:green; text-align:center;">
  Terraform S3 Website Deployed via GitHub Actions!
</h1>
<p style="text-align:center;">This lab was done by Vasu using Terraform + GitHub Actions.</p>
EOF

  content_type = "text/html"
}

