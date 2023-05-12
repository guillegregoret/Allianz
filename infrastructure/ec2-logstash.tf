
data "template_file" "user_data_logstash" {
  template = file("user_data_logstash.tpl")
}

resource "aws_instance" "logstash_instance" {
  ami                    = "ami-04fba13aa6da74c92"
  subnet_id              = module.vpc.private_subnets[0]
  instance_type          = "t3.micro"
  private_ip             = "10.99.3.202"
  iam_instance_profile   = aws_iam_instance_profile.ecs_agent.name
  vpc_security_group_ids = [aws_security_group.sg-ec2-ecs.id]
  ebs_optimized          = "false"
  source_dest_check      = "false"
  key_name               = "terraform_ec2_key"
  user_data              = data.template_file.user_data_logstash.rendered
  private_dns_name_options {
    enable_resource_name_dns_a_record = true
    hostname_type                     = "ip-name"
  }
  root_block_device {
    volume_type           = "gp2"
    volume_size           = "10"
    delete_on_termination = "true"
  }

}
