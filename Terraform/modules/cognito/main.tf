resource "aws_cognito_user_pool" "app_user_pool" {
  name = var.user_pool_name

  auto_verified_attributes = ["email"]

  username_attributes = ["email"]

  password_policy {
    minimum_length    = 8
    require_uppercase = true
    require_lowercase = true
    require_numbers   = true
    require_symbols   = false
  }

  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }
  }
}


resource "aws_cognito_user_pool_client" "client" {
  name         = var.user_pool_client_name
  user_pool_id = aws_cognito_user_pool.app_user_pool.id

  supported_identity_providers = ["COGNITO"]

  callback_urls = var.call_back_urls
  logout_urls   = var.logout_urls

  allowed_oauth_flows                  = ["code"]
  allowed_oauth_flows_user_pool_client = true

  allowed_oauth_scopes = [
    "email",
    "openid",
    "profile"
  ]
}

resource "aws_cognito_user_pool_domain" "main" {
  user_pool_id = aws_cognito_user_pool.app_user_pool.id
  domain       = var.cognito_user_pool_domain
}

resource "aws_cognito_user_pool_ui_customization" "customized_ui" {
  user_pool_id = aws_cognito_user_pool_domain.main.user_pool_id
  css          = file("${path.module}/cognito_ui_src/custom.css")
  image_file   = filebase64("${path.module}/cognito_ui_src/logo.png")
}