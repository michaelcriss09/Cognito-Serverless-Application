output "bucket_domain_name" {
    value = aws_s3_bucket.static_site.bucket_regional_domain_name
}

output "endpoint" {
  value = "${aws_s3_bucket.static_site.bucket}.s3-website.us-east-2.amazonaws.com"
}