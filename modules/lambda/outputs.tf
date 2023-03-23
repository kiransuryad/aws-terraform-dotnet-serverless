# Output values
output "lambda_function_arn" {
  value = aws_lambda_function.lambda_function.arn
}

# Output values for use in API Gateway module
output "lambda_function_invoke_arn" {
  value = aws_lambda_function.lambda_function.invoke_arn
}
