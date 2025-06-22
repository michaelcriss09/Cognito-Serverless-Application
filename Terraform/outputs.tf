output "cognito_login_url" {
  value = "https://${module.cognito.domain}.auth.${var.region}.amazoncognito.com/login?client_id=${module.cognito.client_id}&response_type=code&scope=email+openid+profile&redirect_uri=https%3A%2F%2F${module.cloudfront.cloudfront_domain}%2F${var.htmlfile}"
}
