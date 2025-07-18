locals {
  lambda_configs = {
    insertData = {
      function_name = "insertData"
      filename      = "./modules/lambdas/Functions/insertData.zip"
      handler       = "insertData.lambda_handler"
      runtime       = "python3.9"
    },
    updateData = {
      function_name = "updateData"
      filename      = "./modules/lambdas/Functions/updateData.zip"
      handler       = "updateData.lambda_handler"
      runtime       = "python3.9"
    }
  }

  s3_origin_id = "MyS3Origin"
}
