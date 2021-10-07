provider "aws" {
  region = var.aws_region
}

resource "random_id" "id" {
  byte_length = 4
}

### S3 ###
# s3 bucket to store lambda function code
resource "aws_s3_bucket" "lambda_s3_bucket" {
  bucket = "${var.project_name}-lambda-bucket-${var.environment}-${random_id.id.hex}"

  acl           = "private"
  force_destroy = true
}

# upload zipped lambda function to s3 bucket
resource "aws_s3_bucket_object" "lambda_function_s3_upload" {
  bucket = aws_s3_bucket.lambda_s3_bucket.id

  key = "hello-world.zip"
  # zip is handled by terraform data archive defined in data.tf
  source = data.archive_file.lambda_function_zip.output_path
  etag   = filemd5(data.archive_file.lambda_function_zip.output_path)
}

### Lambda ###
# hello world demo Lambda function
resource "aws_lambda_function" "hello_world_lambda" {
  function_name = "${var.project_name}-hello-lambda-${var.environment}-${random_id.id.hex}"

  s3_bucket = aws_s3_bucket.lambda_s3_bucket.id
  s3_key    = aws_s3_bucket_object.lambda_function_s3_upload.key

  runtime = var.lambda_funtion_runtime
  handler = var.lambda_function_handler

  source_code_hash = data.archive_file.lambda_function_zip.output_base64sha256

  role = aws_iam_role.lambda_exec.arn
}

resource "aws_cloudwatch_log_group" "hello_world_cloudwatch_group" {
  name = "/aws/lambda/${aws_lambda_function.hello_world_lambda.function_name}"

  retention_in_days = 30
}

# lambda function execution role
resource "aws_iam_role" "lambda_exec" {
  name = "${var.project_name}-lambda-exec-${var.environment}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = var.lambda_role_policy_arn

}

### API Gateway ###
# api gateway resources to handle the lambda function HTTP requests
resource "aws_apigatewayv2_api" "lambda_hello_api" {
  name = "${var.project_name}-lambda-hello-api-${var.environment}"

  protocol_type = "HTTP"
}

# api gateway stage 
resource "aws_apigatewayv2_stage" "lambda_hello_api_stage" {
  api_id = aws_apigatewayv2_api.lambda_hello_api.id

  name        = "${var.project_name}-lambda-hello-api-stage-${var.environment}"
  auto_deploy = true

  # stage access log confugiration
  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.hello_api_cloudwatch_group.arn

    format = jsonencode({
      requestId               = "$context.requestId"
      sourceIp                = "$context.identity.sourceIp"
      requestTime             = "$context.requestTime"
      protocol                = "$context.protocol"
      httpMethod              = "$context.httpMethod"
      resourcePath            = "$context.resourcePath"
      routeKey                = "$context.routeKey"
      status                  = "$context.status"
      responseLength          = "$context.responseLength"
      integrationErrorMessage = "$context.integrationErrorMessage"
      }
    )
  }
}

# api gateway to lambda integration
resource "aws_apigatewayv2_integration" "lambda_hello_api_integration" {
  api_id = aws_apigatewayv2_api.lambda_hello_api.id

  integration_uri    = aws_lambda_function.hello_world_lambda.invoke_arn
  integration_type   = var.api_gateway_integration_type
  integration_method = var.api_gateway_integration_method
}

# api gateway to lambda http route definitions
resource "aws_apigatewayv2_route" "lambda_hello_api_route" {
  api_id = aws_apigatewayv2_api.lambda_hello_api.id

  route_key = var.api_gateway_route_key
  target    = "integrations/${aws_apigatewayv2_integration.lambda_hello_api_integration.id}"
}

# api gateway to lambda permissions
resource "aws_lambda_permission" "lambda_hello_api_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.hello_world_lambda.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.lambda_hello_api.execution_arn}/*/*"
}

# api gateway cloudwatch log group create
resource "aws_cloudwatch_log_group" "hello_api_cloudwatch_group" {
  name = "/aws/lambda/${aws_apigatewayv2_api.lambda_hello_api.name}"

  retention_in_days = 30
}


### DNS ###

resource "aws_api_gateway_domain_name" "hello_api_domain_name_resource" {
  certificate_arn = data.aws_acm_certificate.wildcard_cert.arn
  domain_name     = local.api_dns_address

}

resource "aws_route53_record" "hello_api_public" {
  zone_id = var.route53_zone_id
  name    = aws_api_gateway_domain_name.hello_api_domain_name_resource[each.value].domain_name
  type    = "A"

  alias {
    evaluate_target_health = true
    name                   = aws_api_gateway_domain_name.hello_api_domain_name_resource[each.value].cloudfront_domain_name
    zone_id                = aws_api_gateway_domain_name.hello_api_domain_name_resource[each.value].cloudfront_zone_id
  }
  for_each = toset([local.api_dns_address])

}

