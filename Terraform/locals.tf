locals {
  lambda_configs = {
    insertData = {
      function_name = "insertData"
      filename      = "insertData.zip"
      handler       = "insertData.lambda_handler"
      runtime       = "python3.9"
    } #, name{}
  }
}
