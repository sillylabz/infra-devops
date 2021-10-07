# function to zip nodejs code base.
data "archive_file" "lambda_function_zip" {
  type = "zip"

  source_dir  = "${path.module}/hello-world"
  output_path = "${path.module}/hello-world.zip"
}

# wildcard cert data
data "aws_acm_certificate" "wildcard_cert" {
  domain   = "*.${var.domain_name}"
  statuses = ["ISSUED"]
}


locals {
  api_dns_address = "${var.project_name}-${var.environment}.${var.domain_name}"
}


