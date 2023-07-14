##Route53
resource "aws_route53_zone" "main" {
  name = var.domain_name
}

### R53 Records ###
resource "aws_route53_record" "api" {
  name    = aws_apigatewayv2_domain_name.apigateway-domain-name.domain_name
  type    = "A"
  zone_id = aws_route53_zone.main.zone_id

  alias {
    name                   = aws_apigatewayv2_domain_name.apigateway-domain-name.domain_name_configuration[0].target_domain_name
    zone_id                = aws_apigatewayv2_domain_name.apigateway-domain-name.domain_name_configuration[0].hosted_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "root_domain" {
  zone_id = aws_route53_zone.main.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.root_s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.root_s3_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "certificate_validation_record" {
  allow_overwrite = true
  name            = tolist(aws_acm_certificate.ssl_certificate.domain_validation_options)[0].resource_record_name
  records         = [tolist(aws_acm_certificate.ssl_certificate.domain_validation_options)[0].resource_record_value]
  type            = tolist(aws_acm_certificate.ssl_certificate.domain_validation_options)[0].resource_record_type
  zone_id         = aws_route53_zone.main.zone_id
  ttl             = 60
}

##### CloudFlare

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}
resource "cloudflare_record" "NS0" {
  zone_id = var.cloudflare_zone_id
  name    = var.project_name
  value   = aws_route53_zone.main.name_servers.0
  type    = "NS"
  ttl     = 600
}
resource "cloudflare_record" "NS1" {
  zone_id = var.cloudflare_zone_id
  name    = var.project_name
  value   = aws_route53_zone.main.name_servers.1
  type    = "NS"
  ttl     = 600
}
resource "cloudflare_record" "NS2" {
  zone_id = var.cloudflare_zone_id
  name    = var.project_name
  value   = aws_route53_zone.main.name_servers.2
  type    = "NS"
  ttl     = 600
}
resource "cloudflare_record" "NS3" {
  zone_id = var.cloudflare_zone_id
  name    = var.project_name
  value   = aws_route53_zone.main.name_servers.3
  type    = "NS"
  ttl     = 600
}