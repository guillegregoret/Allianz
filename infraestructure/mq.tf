/*
resource "aws_mq_broker" "allianz-mq" {
  broker_name = "allianz-mq"

  engine_type        = "RabbitMQ"
  engine_version     = "3.10.10"
  host_instance_type = "mq.t3.micro"
  publicly_accessible = true
  #security_groups    = [aws_security_group.test.id]

  user {
    username = "allianz_user_mq"
    password = "80EF9A1A04CED5D79F7D161A6039ACF14FA505EEE3EE728248710C674EDC1E13"
  }
}
*/