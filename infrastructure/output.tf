output "target_domain_name" {
  value = aws_apigatewayv2_domain_name.apigateway-domain-name.domain_name_configuration[0].target_domain_name
}
output "api_gateway_endpoint" {
  value = aws_apigatewayv2_api.apigateway.api_endpoint
}