variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "Unique S3 bucket name for website"
  type        = string
  default     = "vasu-simple-website-bucket"  #  change to unique name
}

