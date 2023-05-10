##Route53

resource "aws_route53_zone" "main" {
  name = var.domain_name
}

### R53 Records ###
/*
resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "api.${var.domain_name}"
  type    = "A"

  alias {
    name                   = aws_lb.public-load-balancer.dns_name
    zone_id                = aws_lb.public-load-balancer.zone_id
    evaluate_target_health = true
  }
}
*/

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
  name = var.domain_name
  type = "A"

  alias {
    name = "${aws_cloudfront_distribution.root_s3_distribution.domain_name}"
    zone_id = "${aws_cloudfront_distribution.root_s3_distribution.hosted_zone_id}"
    evaluate_target_health = false
  }
}


