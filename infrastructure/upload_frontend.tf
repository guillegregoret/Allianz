resource "aws_s3_bucket_object" "frontend_html" { 
  for_each     = fileset("frontend/", "*.html")
  bucket       = aws_s3_bucket.root_bucket.id
  key          = each.value
  source       = "frontend/${each.value}"
  etag         = filemd5("frontend/${each.value}")
  content_type = "text/html"
}
resource "aws_s3_bucket_object" "frontend_js" { 
  for_each     = fileset("frontend/", "*.js")
  bucket       = aws_s3_bucket.root_bucket.id
  key          = each.value
  source       = "frontend/${each.value}"
  etag         = filemd5("frontend/${each.value}")
  content_type = "text/javascript"
}
resource "aws_s3_bucket_object" "frontend_css" { 
  for_each     = fileset("frontend/", "*.css")
  bucket       = aws_s3_bucket.root_bucket.id
  key          = each.value
  source       = "frontend/${each.value}"
  etag         = filemd5("frontend/${each.value}")
  content_type = "text/css"
}
resource "aws_s3_bucket_object" "favicon" { 
  for_each     = fileset("frontend/", "*.gif")
  bucket       = aws_s3_bucket.root_bucket.id
  key          = each.value
  source       = "frontend/${each.value}"
  etag         = filemd5("frontend/${each.value}")

}