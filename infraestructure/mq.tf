/*
resource "aws_mq_broker" "rabbit_mq" {
  broker_name = "rabbit_mq"

  engine_type        = "RabbitMQ"
  engine_version     = "3.10.10"
  host_instance_type = "mq.t3.micro"
  security_groups    = [aws_security_group.sg-ec2-ecs.id]
  deployment_mode = "SINGLE_INSTANCE"
  subnet_ids = [module.vpc.private_subnets[0]]
  storage_type  = "ebs"

  user {
    username = "rabbit-user"
    password = "passw0rd-rabbiTMq"
  }
}
*/