variable "filename" {
    description = "lamabda file name: insertData.zip"
}

variable "name" {
    description = "Function name: insertData"
}

variable "role" {
    description = "Lambda role"
}

variable "runtime" {
    description = "Lambda runtime = python3.9"
}

variable "handler"{
    description = "insertData.lambda_handler"
}