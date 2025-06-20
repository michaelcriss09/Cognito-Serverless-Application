variable "api_name"{
    type = string
}

variable "api_type"{
    type = string
    description = "VALUE = REGIONAL"
}

variable "put_m_name" {
    type = string
}

variable "post_m_name"{
    description = "VALUE = POST"
}

variable "options_m_name"{
    description = "value = OPTIONS"
}

variable "post_integration_type" {
    description = "Value = AWS or AWS_PROXY"
}

variable "options_integration_type" {
    description = "Value = MOCK"
}

variable "insertData_lambda_function_invoke_arn"{
    type = string
}

variable "updateData_lambda_function_invoke_arn" {
  type = string
}

variable stage_name {
    type = string
}

variable "insertData_lambda_Function_name" {
    type = string
}

variable "updateData_lambda_Function_name" {
    type = string
}