# Output API Gateway endpoint
output "api_gateway_endpoint" {
  value = module.api_gateway.api_gateway_endpoint
}

# Output Lambda function ARN
output "lambda_function_arn" {
  value = module.lambda.lambda_function_arn
}
