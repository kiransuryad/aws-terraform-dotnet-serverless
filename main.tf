# Define AWS provider
provider "aws" {
  region = "us-east-1"
}

# Include S3 module
module "s3" {
  source      = "./modules/s3"
  bucket_name = "my-s3-bucket-name"
}

# Include Lambda module
module "lambda" {
  source      = "./modules/lambda"
  bucket_name = module.s3.bucket_id

  api_gateway_rest_api_id    = module.api_gateway.api_gateway_rest_api_id
  api_gateway_resource_id    = module.api_gateway.api_gateway_resource_id
  api_gateway_method_id      = module.api_gateway.api_gateway_method_id
  api_gateway_invoke_url     = module.api_gateway.api_gateway_invoke_url
  lambda_function_role_arn   = module.lambda.lambda_function_role_arn
  lambda_function_invoke_arn = module.lambda.lambda_function_invoke_arn
  lambda_function_name       = module.lambda.lambda_function_name
}

# Include API Gateway module
module "api_gateway" {
  source                     = "./modules/api_gateway"
  lambda_function_invoke_arn = module.lambda.lambda_function_invoke_arn
}
