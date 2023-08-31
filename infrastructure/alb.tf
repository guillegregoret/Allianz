##### ALB - Application Load Balancing #####
### ALB Public ###
resource "aws_lb" "public-load-balancer" {
  internal           = false # internal = true else false
  name               = "${var.project_name}-public-alb"
  load_balancer_type = "application"
  subnets            = module.vpc.public_subnets
  #subnets            = [module.vpc.private_subnets[0], module.vpc.private_subnets[1], module.vpc.private_subnets[2]] # Subnets privadas
  security_groups = [aws_security_group.public.id]
}

##### ALB - Target Groups #####

resource "aws_alb_target_group" "service-one-public" {
  name        = "service-one-tg"
  port        = "8082"
  protocol    = "HTTP"
  vpc_id      = module.vpc.vpc_id
  target_type = "ip"


  health_check {
    healthy_threshold   = "2"
    interval            = "15"
    path                = "/actuator/health"
    protocol            = "HTTP"
    unhealthy_threshold = "8"
    timeout             = "6"
  }
}

resource "aws_alb_target_group" "service-two-public" {
  name     = "service-two-tg"
  port     = "8084"
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id


  health_check {
    healthy_threshold   = "2"
    interval            = "15"
    path                = "/actuator/health"
    protocol            = "HTTP"
    unhealthy_threshold = "8"
    timeout             = "6"
  }
}


##### ALB - Listeners #####
resource "aws_lb_listener" "service-one-lb-listener" {
  load_balancer_arn = aws_lb.public-load-balancer.arn
  port              = "8082"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.ssl_certificate.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.service-one-public.id
  }
}

resource "aws_lb_listener" "service-two-lb-listener" {
  load_balancer_arn = aws_lb.public-load-balancer.arn
  port              = "8084"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.ssl_certificate.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.service-two-public.id
  }
}


