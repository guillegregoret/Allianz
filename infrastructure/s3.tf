
## S3 Bucket for static frontend
# S3 bucket for website.

resource "aws_s3_bucket" "root_bucket" {

  bucket = "${var.bucket_name}-${random_string.random_suffix.result}"
  #policy = templatefile("templates/s3-policy.json", { bucket = "${var.bucket_name}-${random_string.random_suffix.result}" })
  cors_rule {
    allowed_headers = ["Authorization", "Content-Length"]
    allowed_methods = ["GET", "POST"]
    allowed_origins = ["https://${var.domain_name}"]
    max_age_seconds = 3000
  }

  #website {
  #  index_document = "index.html"
  #  error_document = "404.html"
  #}
}
resource "aws_s3_bucket_website_configuration" "root_bucket" {
  bucket = aws_s3_bucket.root_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "404.html"
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

resource "aws_s3_bucket_policy" "public_read_access" {
  bucket     = aws_s3_bucket.root_bucket.id
  policy     = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "PublicReadGetObject",
        "Effect": "Allow",
        "Principal": "*",
        "Action": "s3:GetObject",
        "Resource": "arn:aws:s3:::${var.bucket_name}-${random_string.random_suffix.result}/*"
      }
    ]
  }
EOF
  depends_on = [aws_s3_bucket.root_bucket]
}

resource "random_string" "random_suffix" {
  length  = 8
  special = false
  upper   = false
}