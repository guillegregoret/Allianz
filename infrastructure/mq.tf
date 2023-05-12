/*
resource "aws_mq_broker" "allianz-mq" {
  broker_name = "allianz-mq"

  engine_type        = "RabbitMQ"
  engine_version     = "3.10.10"
  host_instance_type = "mq.t3.micro"
  publicly_accessible = true
  #security_groups    = [aws_security_group.test.id]

  user {
    username = var.rabbit_user
    password = var.rabbit_pass
  }
}
*/