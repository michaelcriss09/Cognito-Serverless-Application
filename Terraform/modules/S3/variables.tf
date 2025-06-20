variable "static_site_bucket_name" {
  type = string
}

variable "htmlfile" {
  type = string
}

variable "jsfile" {
  type = string
}

variable "api_url" {
  description = "The API Gateway invoke URL"
  type        = string
}

variable "cssfile" {
  type = string
}

variable "cloudfront_arn" {
  type = string
}