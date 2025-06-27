resource "aws_s3_bucket" "main" {
  bucket = "${var.project_name}-assets-${random_string.suffix.result}"
}
resource "aws_s3_bucket_public_access_block" "main" {
  bucket                  = aws_s3_bucket.main.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
resource "aws_s3_bucket_versioning" "main" {
  bucket = aws_s3_bucket.main.id
  versioning_configuration { status = "Enabled" }
}
resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

