output "client_id" {
  value = aws_cognito_user_pool_client.client.id
}

output "domain" {
  value = aws_cognito_user_pool_domain.main.domain
}