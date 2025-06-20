output "api_invoke_url" {
  value = "https://${aws_api_gateway_rest_api.rest-api.id}.execute-api.us-east-2.amazonaws.com/${var.stage_name}"
}
output "rest_api_id" {
  value = aws_api_gateway_rest_api.rest-api.id
}
