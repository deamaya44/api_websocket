variable "region" {
  default = "us-east-1"
}

variable "lambda_runtime" {
  default = "nodejs20.x"
}

variable "lambda_handler" {
  default = "index.handler"
}

variable "access_key" {
    default = "access_key"
}

variable "secret_key" {
    default = "secret_key"
}