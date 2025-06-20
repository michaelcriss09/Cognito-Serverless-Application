variable "api_name" {
  type    = string
  default = "REST_API_GATEWAY"
}

variable "api_type" {
  type    = string
  default = "REGIONAL"
}

variable "post_m_name" {
  default = "POST"
}

variable "put_m_name" {
  default = "PUT"
}

variable "options_m_name" {
  default = "OPTIONS"
}

variable "post_integration_type" {
  default = "AWS_PROXY"
}

variable "options_integration_type" {
  default = "MOCK"
}


variable "stage_name" {
  default = "my_stage"
}

variable "lambda_Function_name" {
  default = "insertData"
}


variable "static_site_bucket_name" {
  type    = string
  default = "dni-images-2415"
}

variable "htmlfile" {
  type    = string
  default = "app.html"
}

variable "jsfile" {
  type    = string
  default = "script.js"
}

variable "cssfile" {
  type    = string
  default = "styles.css"
}

variable "table_name" {
  type    = string
  default = "Profile-db"
}

variable "hash" {
  type    = string
  default = "userId"
}

variable "billing_mode" {
  type    = string
  default = "PAY_PER_REQUEST"
}

variable "user_pool_name" {
  type = string
  default = "app_user_pool"
}

variable "user_pool_client_name" {
  type = string
  default = "app_user_pool_client"
}

variable "cognito_user_pool_domain" {
  type = string
  default = "myapp-auth-24213"

}

variable "region" {
  default = "us-east-2"
}