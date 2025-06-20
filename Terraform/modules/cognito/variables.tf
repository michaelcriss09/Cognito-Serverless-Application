variable "user_pool_name" {
  type = string
}

variable "user_pool_client_name" {
  type = string
}

variable "call_back_urls" {
  type = list(string)
}

variable "logout_urls" {
  type = list(string)
}


variable "cognito_user_pool_domain" {
  type = string
}
