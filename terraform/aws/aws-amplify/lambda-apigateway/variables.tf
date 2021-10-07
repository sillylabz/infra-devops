variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project Name"
  type        = string
  default     = "demo"
}

variable "environment" {
  description = "Environment to deploy project. example: dev, qa, stage, prod."
  type        = string
  default     = "dev"
}

# lambda function vars
variable "lambda_funtion_runtime" {
  description = "Runtime to run the lambda function. example nodejs12.x"
  type        = string
  default     = "nodejs12.x"
}

variable "lambda_function_handler" {
  description = "Lambda funtion handler. example hello.handler"
  type        = string
  default     = "hello.handler"
}

variable "lambda_role_policy_arn" {
  description = "Role to attach to lambda function execution policy."
  type        = string
  default     = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# api gateway vars
variable "api_gateway_integration_type" {
  description = "API Gateway to lambda Integration type."
  type        = string
  default     = "AWS_PROXY"
}

variable "api_gateway_integration_method" {
  description = "API Gateway to lambda Integration method."
  type        = string
  default     = "POST"
}

variable "api_gateway_route_key" {
  description = "API Gateway to lambda request routing key."
  type        = string
  default     = "GET /hello"
}

# route53 dns for api gateway
variable "domain_name" {
  description = "Main route 53 dns domain name. Must have existing domain."
  type        = string
  default     = "example.com"
}

variable "create_custom_domain" {
  description = "create custom domin for the api gateway resource."
  type        = string
  default     = "yes"
}

variable "create_certificate" {
  description = "create custom acm cert for the created api gateway domain."
  type        = string
  default     = "yes"
}

variable "route53_zone_id" {
  description = "Main route 53 dns hosted id."
  type        = string
  default     = ""
}











