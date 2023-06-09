# Generate a random name for the S3 bucket
resource "random_string" "s3_bucket_suffix" {
  length  = 8
  special = false
}

# Create S3 bucket
resource "aws_s3_bucket" "s3_bucket" {
  bucket = "my-bucket-${replace(lower("${random_string.s3_bucket_suffix.result}"), "/+", "-_")}"
}

# Define S3 bucket public access settings
resource "aws_s3_bucket_public_access_block" "s3_bucket_public_access_block" {
  bucket = aws_s3_bucket.s3_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


