resource "aws_iam_role" "lambda_role" {
  name = "Lambda_s3_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    tag-key = "tag-value"
  }
}

data "aws_iam_policy" "AmazonS3FullAccess" {
  arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

data "aws_iam_policy" "AWSLambdaBasicExecutionRole" {
  arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

data "aws_iam_policy" "AmazonTextractFullAccess" {
  arn = "arn:aws:iam::aws:policy/AmazonTextractFullAccess"
}

data "aws_iam_policy" "AmazonDynamoDBFullAccess" {
  arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}



resource "aws_iam_role_policy_attachment" "s3_full_access" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = data.aws_iam_policy.AmazonS3FullAccess.arn
}

resource "aws_iam_role_policy_attachment" "logs_access" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = data.aws_iam_policy.AWSLambdaBasicExecutionRole.arn
}

resource "aws_iam_role_policy_attachment" "text_extract" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = data.aws_iam_policy.AmazonTextractFullAccess.arn
}

resource "aws_iam_role_policy_attachment" "dynamodb" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = data.aws_iam_policy.AmazonDynamoDBFullAccess.arn
}

module "lambdaFunction" {
  for_each = local.lambda_configs

  name     = each.value.function_name
  filename = each.value.filename
  handler  = each.value.handler
  runtime  = each.value.runtime
  role     = aws_iam_role.lambda_role.arn

  source = "./modules/lambdas"
}

module "api_gateway" {

  api_name                              = var.api_name
  api_type                              = var.api_type
  post_m_name                           = var.post_m_name
  post_integration_type                 = var.post_integration_type
  options_integration_type              = var.options_integration_type
  options_m_name                        = var.options_m_name
  put_m_name                            = var.put_m_name
  updateData_lambda_Function_name       = module.lambdaFunction["updateData"].function_name
  updateData_lambda_function_invoke_arn = module.lambdaFunction["updateData"].invoke_arn
  insertData_lambda_Function_name       = module.lambdaFunction["insertData"].function_name
  insertData_lambda_function_invoke_arn = module.lambdaFunction["insertData"].invoke_arn
  stage_name                            = var.stage_name

  source = "./modules/api-gateway"
}

module "s3_bucket" {
  static_site_bucket_name = var.static_site_bucket_name
  api_url                 = module.api_gateway.api_invoke_url
  htmlfile                = var.htmlfile
  cssfile                 = var.cssfile
  jsfile                  = var.jsfile
  cloudfront_arn          = module.cloudfront.cloudfront_arn

  source = "./modules/S3"
}

resource "aws_dynamodb_table" "dynamodb" {
  name         = var.table_name
  hash_key     = var.hash
  billing_mode = var.billing_mode

  attribute {
    name = var.hash
    type = "S"
  }
}

module "cloudfront" {
origin_id = local.s3_origin_id
domain_name = module.s3_bucket.bucket_domain_name
default_root_object = var.htmlfile
source = "./modules/cloudfront"

}

module "cognito" {
  user_pool_name = var.user_pool_name
  user_pool_client_name = var.user_pool_client_name
  call_back_urls = ["${module.cloudfront.cloudfront_url}/app.html"]
  logout_urls = ["${module.cloudfront.cloudfront_url}/logout"]
  cognito_user_pool_domain = var.cognito_user_pool_domain

  source = "./modules/cognito"
}
