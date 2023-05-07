resource "aws_apigatewayv2_api" "apigateway" {
  name          = "example-http-api"
  protocol_type = "HTTP"
}
# Service One API 
resource "aws_apigatewayv2_integration" "service-one-integration" {
  api_id           = aws_apigatewayv2_api.apigateway.id
  description      = "Example with a load balancer"
  integration_type = "HTTP_PROXY"
  integration_uri  = aws_lb_listener.service-one-lb-listener.arn

  integration_method = "ANY"
  connection_type    = "VPC_LINK"
  connection_id      = aws_apigatewayv2_vpc_link.example.id

  tls_config {
    server_name_to_verify = "api.allianz.gregoret.com.ar"
  }
}

resource "aws_apigatewayv2_route" "service-one-route" {
  api_id    = aws_apigatewayv2_api.apigateway.id
  route_key = "ANY /service-one"

  target = "integrations/${aws_apigatewayv2_integration.service-one-integration.id}"
}

# Service Two API 
resource "aws_apigatewayv2_integration" "service-two-integration" {
  api_id           = aws_apigatewayv2_api.apigateway.id
  description      = "Example with a load balancer"
  integration_type = "HTTP_PROXY"
  integration_uri  = aws_lb_listener.service-two-lb-listener.arn

  integration_method = "ANY"
  connection_type    = "VPC_LINK"
  connection_id      = aws_apigatewayv2_vpc_link.example.id

  tls_config {
    server_name_to_verify = "api.allianz.gregoret.com.ar"
  }
}

resource "aws_apigatewayv2_route" "service-two-route" {
  api_id    = aws_apigatewayv2_api.apigateway.id
  route_key = "ANY /service/{proxy+}"

  target = "integrations/${aws_apigatewayv2_integration.service-two-integration.id}"
}

#General
resource "aws_apigatewayv2_vpc_link" "example" {
  name               = "example"
  security_group_ids = [aws_security_group.public.id]
  subnet_ids         = [module.vpc.private_subnets[0],module.vpc.private_subnets[1],module.vpc.private_subnets[2]]
}

resource "aws_apigatewayv2_stage" "example" {
  api_id = aws_apigatewayv2_api.apigateway.id
  name   = "$default"
  auto_deploy = true
}