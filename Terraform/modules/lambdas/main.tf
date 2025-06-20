data "archive_file" "insertImage" {
  type        = "zip"
  source_file = "${path.module}/Functions/${var.name}.py"
  output_path = var.filename
}


resource "aws_lambda_function" "lambda_function" {

  filename      = var.filename
  function_name = var.name
  role          = var.role
  handler       = var.handler

  source_code_hash = filebase64sha256(var.filename)

  runtime = var.runtime

  environment {
    variables = {
      foo = "bar"
    }
  }
}