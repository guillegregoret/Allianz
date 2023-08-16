/*
resource "aws_apigatewayv2_api" "apigateway" {
  name          = "${var.project_name}-api-gateway"
  protocol_type = "HTTP"
  depends_on    = [time_sleep.wait_60_seconds_services]
}
# Ownership of domain name
resource "aws_apigatewayv2_domain_name" "apigateway-domain-name" {
  domain_name = "api.${var.project_name}.gregoret.com.ar"

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
  api_id             = aws_apigatewayv2_api.apigateway.id
  description        = "Service one integration with API Gateway"
  integration_type   = "HTTP_PROXY"
  integration_uri    = aws_lb_listener.service-one-lb-listener.arn
  integration_method = "GET"
  connection_type    = "VPC_LINK"
  connection_id      = aws_apigatewayv2_vpc_link.vpc-link.id

  tls_config {
    server_name_to_verify = "api.${var.project_name}.gregoret.com.ar"
  }

  request_parameters = {
    "overwrite:path" = "$request.path.proxy"
  }
}

resource "aws_apigatewayv2_route" "service-one-route" {
  api_id    = aws_apigatewayv2_api.apigateway.id
  route_key = "GET /service-one/{proxy+}"

  target = "integrations/${aws_apigatewayv2_integration.service-one-integration.id}"
  lifecycle {

    ignore_changes = [
      target,
    ]
  }
}

# Service Two API 

resource "aws_apigatewayv2_integration" "service-two-integration" {
  api_id           = aws_apigatewayv2_api.apigateway.id
  description      = "Service two integration with API Gateway"
  integration_type = "HTTP_PROXY"
  integration_uri  = aws_lb_listener.service-two-lb-listener.arn

  integration_method = "GET"
  connection_type    = "VPC_LINK"
  connection_id      = aws_apigatewayv2_vpc_link.vpc-link.id

  tls_config {
    server_name_to_verify = "api.${var.project_name}.gregoret.com.ar"
  }

  request_parameters = {
    "overwrite:path" = "$request.path.proxy"
  }
}

resource "aws_apigatewayv2_route" "service-two-route" {
  api_id    = aws_apigatewayv2_api.apigateway.id
  route_key = "GET /service-two/{proxy+}"

  target = "integrations/${aws_apigatewayv2_integration.service-two-integration.id}"
  lifecycle {

    ignore_changes = [
      target,
    ]
  }
}

#General
resource "aws_apigatewayv2_vpc_link" "vpc-link" {
  name               = "vpc-link"
  security_group_ids = [aws_security_group.public.id]
  subnet_ids         = [module.vpc.private_subnets[0], module.vpc.private_subnets[1], module.vpc.private_subnets[2]]
}

resource "aws_apigatewayv2_stage" "apigw-stage" {
  api_id      = aws_apigatewayv2_api.apigateway.id
  name        = var.environment
  auto_deploy = false
  lifecycle {
    ignore_changes = [
      # This is needed to be ignored as we are updating the route
      #by null resource and next apply should not revert the changes #
      deployment_id,
    ]
  }
}


#####

resource "aws_apigatewayv2_deployment" "apigw" {
  api_id      = aws_apigatewayv2_api.apigateway.id
  description = "Terraform managed deployment of the proxy routes"
  lifecycle {
    create_before_destroy = true
  }
  depends_on = [aws_apigatewayv2_route.service-one-route, aws_apigatewayv2_route.service-two-route]
}

resource "null_resource" "update_routes" {
  provisioner "local-exec" {
    command = "aws apigatewayv2 update-route --profile acloudguru --api-id ${aws_apigatewayv2_api.apigateway.id} --route-id ${aws_apigatewayv2_route.service-one-route.id} --target integrations/${aws_apigatewayv2_integration.service-one-integration.id}"
  }
  provisioner "local-exec" {
    command = "aws apigatewayv2 update-route --profile acloudguru --api-id ${aws_apigatewayv2_api.apigateway.id} --route-id ${aws_apigatewayv2_route.service-two-route.id} --target integrations/${aws_apigatewayv2_integration.service-two-integration.id}"
  }
  provisioner "local-exec" {
    command = "aws apigatewayv2 create-deployment --profile acloudguru --api-id ${aws_apigatewayv2_api.apigateway.id} --stage ${var.environment}"
  }
  depends_on = [aws_apigatewayv2_deployment.apigw]
}
*/