provider "aws" {
  region = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

# Rol para la Lambda
resource "aws_iam_role" "lambda_role" {
  name = "lambda_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
      },
    ],
  })
}

# Política para que la Lambda pueda escribir logs en CloudWatch
resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Función Lambda para manejar conexiones
resource "aws_lambda_function" "connect_lambda" {
  function_name = "connect_function"
  runtime       = var.lambda_runtime
  handler       = var.lambda_handler
  role          = aws_iam_role.lambda_role.arn

  filename = "lambda.zip"  # El código de la Lambda debe estar en este archivo zip

  source_code_hash = filebase64sha256("lambda.zip")
}

# Función Lambda para manejar desconexiones
resource "aws_lambda_function" "disconnect_lambda" {
  function_name = "disconnect_function"
  runtime       = var.lambda_runtime
  handler       = var.lambda_handler
  role          = aws_iam_role.lambda_role.arn

  filename = "lambda.zip"

  source_code_hash = filebase64sha256("lambda.zip")
}

# Función Lambda para manejar mensajes por defecto
resource "aws_lambda_function" "default_lambda" {
  function_name = "default_function"
  runtime       = var.lambda_runtime
  handler       = var.lambda_handler
  role          = aws_iam_role.lambda_role.arn

  filename = "lambda.zip"

  source_code_hash = filebase64sha256("lambda.zip")
}

# API Gateway WebSocket
resource "aws_apigatewayv2_api" "websocket_api" {
  name                    = "websocket-api"
  protocol_type           = "WEBSOCKET"
  route_selection_expression = "$request.body.action"
}

# Rutas del WebSocket
resource "aws_apigatewayv2_route" "connect_route" {
  api_id    = aws_apigatewayv2_api.websocket_api.id
  route_key = "$connect"
  target    = "integrations/${aws_apigatewayv2_integration.connect_integration.id}"
}


resource "aws_apigatewayv2_route" "disconnect_route" {
  api_id    = aws_apigatewayv2_api.websocket_api.id
  route_key = "$disconnect"
  target    = "integrations/${aws_apigatewayv2_integration.disconnect_integration.id}"
}

resource "aws_apigatewayv2_route" "default_route" {
  api_id    = aws_apigatewayv2_api.websocket_api.id
  route_key = "$default"
  target    = "integrations/${aws_apigatewayv2_integration.default_integration.id}"
}

# Integraciones para las rutas
resource "aws_apigatewayv2_integration" "connect_integration" {
  api_id             = aws_apigatewayv2_api.websocket_api.id
  integration_type   = "AWS_PROXY"
  integration_uri    = aws_lambda_function.connect_lambda.arn
  integration_method = "POST"
}
resource "aws_apigatewayv2_integration" "disconnect_integration" {
  api_id             = aws_apigatewayv2_api.websocket_api.id
  integration_type   = "AWS_PROXY"
  integration_uri    = aws_lambda_function.disconnect_lambda.arn
  integration_method = "POST"
}
resource "aws_apigatewayv2_integration" "default_integration" {
  api_id             = aws_apigatewayv2_api.websocket_api.id
  integration_type   = "AWS_PROXY"
  integration_uri    = aws_lambda_function.default_lambda.arn
  integration_method = "POST"
}

# resource "aws_apigatewayv2_integration" "disconnect_integration" {
#   api_id           = aws_apigatewayv2_api.websocket_api.id
#   integration_type = "AWS_PROXY"
#   integration_uri  = aws_lambda_function.disconnect_lambda.invoke_arn
# }

# resource "aws_apigatewayv2_integration" "default_integration" {
#   api_id           = aws_apigatewayv2_api.websocket_api.id
#   integration_type = "AWS_PROXY"
#   integration_uri  = aws_lambda_function.default_lambda.invoke_arn
# }

# Asociar rutas con integraciones
resource "aws_apigatewayv2_route_response" "connect_route_response" {
  api_id    = aws_apigatewayv2_api.websocket_api.id
  route_id  = aws_apigatewayv2_route.connect_route.id
  route_response_key = "$default"
}

resource "aws_apigatewayv2_route_response" "disconnect_route_response" {
  api_id    = aws_apigatewayv2_api.websocket_api.id
  route_id  = aws_apigatewayv2_route.disconnect_route.id
  route_response_key = "$default"
}

resource "aws_apigatewayv2_route_response" "default_route_response" {
  api_id    = aws_apigatewayv2_api.websocket_api.id
  route_id  = aws_apigatewayv2_route.default_route.id
  route_response_key = "$default"
}

# Despliegue del API
resource "aws_apigatewayv2_stage" "dev_stage" {
  api_id      = aws_apigatewayv2_api.websocket_api.id
  name        = "dev"
  auto_deploy = true
}
