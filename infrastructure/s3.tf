
## S3 Bucket for static frontend
# S3 bucket for website.

resource "aws_s3_bucket" "root_bucket" {

  bucket = var.bucket_name
  #policy = templatefile("templates/s3-policy.json", { bucket = var.bucket_name })
  cors_rule {
    allowed_headers = ["Authorization", "Content-Length"]
    allowed_methods = ["GET", "POST"]
    allowed_origins = ["https://${var.domain_name}"]
    max_age_seconds = 3000
  }

  website {
    index_document = "index.html"
    error_document = "404.html"
  }
}

resource "aws_s3_bucket_public_access_block" "pab" {
  bucket = aws_s3_bucket.root_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_ownership_controls" "ownership-controls" {
  bucket = aws_s3_bucket.root_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "bucket-acl" {
  depends_on = [
    aws_s3_bucket_public_access_block.pab,
    aws_s3_bucket_ownership_controls.ownership-controls,
  ]

  bucket = aws_s3_bucket.root_bucket.id
  acl    = "public-read"
}
