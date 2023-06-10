resource "aws_apigatewayv2_api" "apigateway" {
  name          = "allianz-api-gateway"
  protocol_type = "HTTP"
  depends_on = [time_sleep.wait_120_seconds_services]
}
# Ownership of domain name
resource "aws_apigatewayv2_domain_name" "apigateway-domain-name" {
  domain_name = "api.allianz.gregoret.com.ar"

  domain_name_configuration {
    certificate_arn = aws_acm_certificate.ssl_certificate.arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }
  depends_on = [aws_acm_certificate_validation.cert_validation]
}
# Domain Mapping
resource "aws_apigatewayv2_api_mapping" "api-mapping" {
  api_id      = aws_apigatewayv2_api.apigateway.id
  domain_name = aws_apigatewayv2_domain_name.apigateway-domain-name.id
  stage       = aws_apigatewayv2_stage.apigw-stage.id
}

# Service One API 
resource "aws_apigatewayv2_integration" "service-one-integration" {
  api_id           = aws_apigatewayv2_api.apigateway.id
  description      = "Service one integration with API Gateway"
  integration_type = "HTTP_PROXY"
  integration_uri  = aws_lb_listener.service-one-lb-listener.arn

  integration_method = "ANY"
  connection_type    = "VPC_LINK"
  connection_id      = aws_apigatewayv2_vpc_link.vpc-link.id

  tls_config {
    server_name_to_verify = "api.allianz.gregoret.com.ar"
  }

  request_parameters = {
    "overwrite:path" = "$request.path.proxy"
  }
}

resource "aws_apigatewayv2_route" "service-one-route" {
  api_id    = aws_apigatewayv2_api.apigateway.id
  route_key = "ANY /service-one/{proxy+}"

  target = "integrations/${aws_apigatewayv2_integration.service-one-integration.id}"
}

# Service Two API 
resource "aws_apigatewayv2_integration" "service-two-integration" {
  api_id           = aws_apigatewayv2_api.apigateway.id
  description      = "Service two integration with API Gateway"
  integration_type = "HTTP_PROXY"
  integration_uri  = aws_lb_listener.service-two-lb-listener.arn

  integration_method = "ANY"
  connection_type    = "VPC_LINK"
  connection_id      = aws_apigatewayv2_vpc_link.vpc-link.id

  tls_config {
    server_name_to_verify = "api.allianz.gregoret.com.ar"
  }

  request_parameters = {
    "overwrite:path" = "$request.path.proxy"
  }
}

resource "aws_apigatewayv2_route" "service-two-route" {
  api_id    = aws_apigatewayv2_api.apigateway.id
  route_key = "ANY /service-two/{proxy+}"

  target = "integrations/${aws_apigatewayv2_integration.service-two-integration.id}"
}

#General
resource "aws_apigatewayv2_vpc_link" "vpc-link" {
  name               = "vpc-link"
  security_group_ids = [aws_security_group.public.id]
  subnet_ids         = [module.vpc.private_subnets[0], module.vpc.private_subnets[1], module.vpc.private_subnets[2]]
}

resource "aws_apigatewayv2_stage" "apigw-stage" {
  api_id      = aws_apigatewayv2_api.apigateway.id
  name        = "$default"
  auto_deploy = true
}