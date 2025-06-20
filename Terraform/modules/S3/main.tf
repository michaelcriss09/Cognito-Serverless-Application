resource "aws_s3_bucket" "static_site" {
  bucket = var.static_site_bucket_name
}


resource "aws_s3_bucket_website_configuration" "site_config" {
  bucket = aws_s3_bucket.static_site.bucket

  index_document {
    suffix = "app.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.static_site.bucket

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.static_site.bucket

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "AllowCloudFrontAccessViaOAC"
        Effect    = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "${aws_s3_bucket.static_site.arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = var.cloudfront_arn
          }
        }
      }
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.public_access]
}


resource "null_resource" "prepare_app_js" {
  provisioner "local-exec" {
    command = "sed 's|var API_ENDPOINT = \\\"HERE\\\";|var API_ENDPOINT = \\\"${var.api_url}\\\";|' ${path.module}/../../../src/script.js.template > ${path.module}/../../../src/script.js"
  }
}

resource "aws_s3_object" "jsfile" {
  bucket       = aws_s3_bucket.static_site.bucket
  key          = var.jsfile
  source = "${path.module}/../../../src/${var.jsfile}"
  content_type = "application/javascript"
}

resource "aws_s3_object" "htmlfile" {
  bucket       = aws_s3_bucket.static_site.bucket
  key          = var.htmlfile
  source = "${path.module}/../../../src/${var.htmlfile}"
  content_type = "text/html"
}

resource "aws_s3_object" "cssfile" {
  bucket       = aws_s3_bucket.static_site.bucket
  key          = var.cssfile
  source = "${path.module}/../../../src/${var.cssfile}"
  content_type = "text/css"
}

resource "aws_s3_object" "uploads" {
  bucket = aws_s3_bucket.static_site.bucket
  key = "uploads/"
  acl = "private"  
  content = ""
}