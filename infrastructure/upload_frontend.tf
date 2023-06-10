resource "aws_s3_bucket_object" "objects" { #rename a frontend
for_each = fileset("frontend/", "*")
bucket = aws_s3_bucket.root_bucket.id
key = each.value
source = "frontend/${each.value}"
etag = filemd5("frontend/${each.value}")
}