output "api_gateway_rest_api_id" {
  value = aws_api_gateway_rest_api.api_gateway.id
}

output "api_gateway_resource_id" {
  value = aws_api_gateway_resource.api_gateway_resource.id
}

output "api_gateway_method_id" {
  value = aws_api_gateway_method.api_gateway_method.id
}

output "api_gateway_deployment_id" {
  value = aws_api_gateway_deployment.api_gateway_deployment.id
}

output "api_gateway_invoke_url" {
  value = aws_api_gateway_deployment.api_gateway_deployment.invoke_url
}
