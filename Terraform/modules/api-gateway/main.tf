resource "aws_api_gateway_rest_api" "rest-api" {
  name        = var.api_name
  description = "Backend REST API Gateway"

  endpoint_configuration {
    types = [var.api_type]
  }
}


# POST method 
resource "aws_api_gateway_method" "post" {
  rest_api_id   = aws_api_gateway_rest_api.rest-api.id
  resource_id   = aws_api_gateway_rest_api.rest-api.root_resource_id
  http_method   = var.post_m_name # http_method = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "post_integration" {
  rest_api_id             = aws_api_gateway_rest_api.rest-api.id
  resource_id             = aws_api_gateway_rest_api.rest-api.root_resource_id
  http_method             = aws_api_gateway_method.post.http_method
  integration_http_method = var.post_m_name
  type                    = var.post_integration_type
  uri                     = var.insertData_lambda_function_invoke_arn
}


# OPTIONS method 
resource "aws_api_gateway_method" "options" {    
  rest_api_id   = aws_api_gateway_rest_api.rest-api.id
  resource_id   = aws_api_gateway_rest_api.rest-api.root_resource_id
  http_method   = var.options_m_name   # http_method = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "options_integration" {
  rest_api_id = aws_api_gateway_rest_api.rest-api.id
  resource_id = aws_api_gateway_rest_api.rest-api.root_resource_id
  http_method = aws_api_gateway_method.options.http_method
  type        = var.options_integration_type

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_method_response" "options_method_response" {
  depends_on  = [aws_api_gateway_integration.options_integration]
  rest_api_id = aws_api_gateway_rest_api.rest-api.id
  resource_id = aws_api_gateway_rest_api.rest-api.root_resource_id
  http_method = aws_api_gateway_method.options.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
  }
}

resource "aws_api_gateway_integration_response" "options_200_ir" {
  rest_api_id = aws_api_gateway_rest_api.rest-api.id
  resource_id = aws_api_gateway_rest_api.rest-api.root_resource_id
  http_method = aws_api_gateway_method.options.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'OPTIONS'"
  }

  response_templates = {
    "application/json" = ""
  }

  depends_on = [
    aws_api_gateway_method_response.options_method_response,
    aws_api_gateway_integration.options_integration
  ]
}


# Deployment and Stage
resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = aws_api_gateway_rest_api.rest-api.id
  triggers = {
    redeployment = timestamp()
  }
  depends_on = [aws_api_gateway_integration.post_integration, aws_api_gateway_integration.options_integration]
}

resource "aws_api_gateway_stage" "stage" {
  rest_api_id   = aws_api_gateway_rest_api.rest-api.id
  deployment_id = aws_api_gateway_deployment.deployment.id
  stage_name    = var.stage_name

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lambda_permission" "allow_apigateway_invoke" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_Function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.rest-api.execution_arn}/${var.stage_name}/*/*"
}
