## Resource value outputs

# Lambda s3 code bucket name
output "lambda_s3_bucket_name" {
  description = "The name of the s3 bucket where the labda funtion code is stored."
  value       = aws_s3_bucket.lambda_s3_bucket.id
}

# Lambda function name.
output "function_name" {
  description = "Name of the Lambda function."
  value       = aws_lambda_function.hello_world_lambda.function_name
}

# API Gateway stage url
output "stage_base_url" {
  description = "Base URL for API Gateway stage."
  value       = aws_apigatewayv2_stage.lambda_hello_api_stage.invoke_url
}

# API Gateway  url
output "base_url" {
  description = "Base URL for API Gateway."
  value       = aws_apigatewayv2_api.lambda_hello_api.api_endpoint
}

