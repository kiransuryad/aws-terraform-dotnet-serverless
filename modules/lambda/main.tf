module "lambda" {
  source        = "./"
  function_name = var.function_name
  s3_bucket     = var.s3_bucket

  // Pass in the API Gateway resources as variables
  api_gateway_rest_api_id = var.api_gateway_rest_api_id
  api_gateway_resource_id = var.api_gateway_resource_id
  api_gateway_method_id   = var.api_gateway_method_id
  api_gateway_invoke_url  = var.api_gateway_invoke_url

  // Output the Lambda function information
  output "lambda_function_name" {
    value = module.lambda.lambda_function_name
  }

  output "lambda_function_invoke_arn" {
    value = module.lambda.lambda_function_invoke_arn
  }

  output "lambda_function_role_arn" {
    value = module.lambda.lambda_function_role_arn
  }
}


# Define IAM role for Lambda function
resource "aws_iam_role" "lambda_role" {
  name = "new_lambda_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      Sid = ""
    }]
  })
}

# Define policy for Lambda function
resource "aws_iam_policy" "lambda_policy" {
  name = "lambda_policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action   = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"]
      Effect   = "Allow"
      Resource = "arn:aws:logs:*:*:*"
      }, {
      Action   = ["s3:GetObject", "s3:PutObject"]
      Effect   = "Allow"
      Resource = "arn:aws:s3:::${var.bucket_name}/*"

    }]
  })
}

# Attach policy to IAM role
resource "aws_iam_role_policy_attachment" "lambda_role_policy_attachment" {
  policy_arn = aws_iam_policy.lambda_policy.arn
  role       = aws_iam_role.lambda_role.name
}

resource "aws_lambda_permission" "lambda_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_function.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.api_gateway.execution_arn}/*/${aws_api_gateway_method.api_gateway_method.http_method}${aws_api_gateway_resource.api_gateway_resource.path}"
}

# Define Lambda function
resource "aws_lambda_function" "lambda_function" {
  function_name = "my-lambda-function"
  handler       = "my-assembly::my-namespace::my-function"
  runtime       = "dotnet6"
  role          = aws_iam_role.lambda_role.arn
  filename      = "${path.module}/AspNetCoreFunction-CodeUri-Or-ImageUri-638144845084776922-638144845235965997.zip"
}

