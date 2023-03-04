resource "aws_iam_role" "ecs-instance-role" {
  name               = "ecs-instance-role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.ecs-instance-policy.json
}
/*
resource "aws_iam_role" "ecsInstanceRole" {
  name               = "ecsInstanceRole"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.ecsInstanceRole-policy.json
}
*/
data "aws_iam_policy_document" "ecs-instance-policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}
data "aws_iam_policy_document" "ecsInstanceRole-policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}
resource "aws_iam_role_policy_attachment" "ecs-instance-role-attachment" {
  role       = aws_iam_role.ecs-instance-role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ecs-instance-profile" {
  name = "ecs-instance-profile"
  path = "/"
  role = aws_iam_role.ecs-instance-role.id
}

resource "aws_iam_role" "ecs-service-role" {
  name               = "ecs-service-role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.ecs-service-policy.json
}

resource "aws_iam_role_policy_attachment" "ecs-service-role-attachment" {
  role       = aws_iam_role.ecs-service-role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}

data "aws_iam_policy_document" "ecs-service-policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs.amazonaws.com"]
    }
  }
}

####################
data "aws_iam_policy_document" "ecs_agent" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_agent" {
  name               = "ecs-agent"
  assume_role_policy = data.aws_iam_policy_document.ecs_agent.json
}

resource "aws_iam_role_policy_attachment" "Cloudwatch_FullAccess" {
  role       = aws_iam_role.ecs_agent.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}

resource "aws_iam_role_policy_attachment" "Cloudwatch_FullAccess_task_role" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}

resource "aws_iam_role_policy_attachment" "Cloudwatch_FullAccess_task_execution" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}

resource "aws_iam_role_policy_attachment" "ecs_agent" {
  role       = aws_iam_role.ecs_agent.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
  depends_on = [aws_iam_role.ecs_agent]
}

resource "aws_iam_instance_profile" "ecs_agent" {
  name = "ecs-agent"
  role = aws_iam_role.ecs_agent.name
}
####################
#########################################################
# AWS ECS-CLUSTER
#########################################################

resource "aws_ecs_cluster" "cluster" {
  name = "ecs-allianz-cluster"
}

###########################################################
# AWS ECS-EC2
###########################################################
resource "aws_instance" "ec2_instance" {
  ami                    = "ami-02861932a7d48032d"
  subnet_id              = module.vpc.private_subnets[0]
  instance_type          = "t3a.medium"
  iam_instance_profile   = aws_iam_instance_profile.ecs_agent.name
  vpc_security_group_ids = [aws_security_group.sg-ec2-ecs.id]
  ebs_optimized          = "false"
  source_dest_check      = "false"
  key_name               = "terraform_ec2_key"
  user_data              = data.template_file.user_data.rendered
  root_block_device {
    volume_type           = "gp2"
    volume_size           = "10"
    delete_on_termination = "true"
  }

  lifecycle {
    ignore_changes = [key_name, ebs_optimized, private_ip]
  }
}

data "template_file" "user_data" {
  template = file("user_data.tpl")
}

############################################################
# ECS - Service Two                                        #
############################################################

############################################################
# AWS ECS-TASK
############################################################

resource "aws_ecs_task_definition" "task_definition_service_two" {
  container_definitions = data.template_file.task_definition_service_two_json.rendered # task definition json file location
  #execution_role_arn       = aws_iam_instance_profile.ecsTaskExecutionRole.arn
  family                   = "allianz-service-two" # task name
  network_mode             = "bridge"              # network mode awsvpc, brigde
  memory                   = "1024"
  cpu                      = "1024"
  requires_compatibilities = ["EC2"] # Fargate or EC2
  #task_role_arn            = aws_iam_instance_profile.ecsTaskExecutionRole.arn
  depends_on = [aws_db_instance.allianz_mysql, aws_instance.consul_instance, aws_instance.logstash_instance]
}

data "template_file" "task_definition_service_two_json" {
  template = file("task_definition_service_two.json")

  vars = {
    CONSUL_HOST   = aws_instance.consul_instance.private_dns
    CONSUL_PORT   = var.consul_port
    RDS_HOST      = aws_db_instance.allianz_mysql.endpoint
    RDS_DB        = var.rds_db_name
    RDS_USER      = var.rds_username
    RDS_PASS      = var.rds_password
    LOGSTASH_HOST = aws_instance.logstash_instance.private_dns
    LOGSTASH_PORT = "5001"
    RABBIT_HOST = "b-a2d3c8ac-eebc-43d5-aa2b-9b917560c582.mq.us-east-1.amazonaws.com"
    RABBIT_USER = "allianz_user_mq"
    RABBIT_PASS = "80EF9A1A04CED5D79F7D161A6039ACF14FA505EEE3EE728248710C674EDC1E13"
  }

}


##############################################################
# AWS ECS-SERVICE
##############################################################

resource "aws_ecs_service" "allianz-service-two-service" {
  cluster         = aws_ecs_cluster.cluster.id                              # ecs cluster id
  desired_count   = 1                                                       # no of task running
  launch_type     = "EC2"                                                   # Cluster type ECS OR FARGATE
  name            = "allianz-service-two-service"                           # Name of service
  task_definition = aws_ecs_task_definition.task_definition_service_two.arn # Attaching Task to service


  load_balancer {
    container_name   = "allianz-service-two" #"container_${var.component}_${var.environment}"
    container_port   = "8084"
    target_group_arn = aws_alb_target_group.service-two-public.arn # attaching load_balancer target group to ecs
  }
  depends_on = [aws_security_group.sg-ec2-ecs, time_sleep.wait_120_seconds]
}

############################################################
# ECS - Service One                                        #
############################################################

############################################################
# AWS ECS-TASK
############################################################

resource "aws_ecs_task_definition" "task_definition_service_one" {
  container_definitions = data.template_file.task_definition_service_one_json.rendered # task definition json file location
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  family                   = "allianz-service-one" # task name
  network_mode             = "awsvpc"              # network mode awsvpc, brigde
  memory                   = "1024"
  cpu                      = "512"
  requires_compatibilities = ["FARGATE"] # Fargate or EC2

  depends_on = [aws_db_instance.allianz_mysql, aws_instance.consul_instance, aws_instance.logstash_instance, aws_docdb_cluster_instance.cluster_instances]
}

data "template_file" "task_definition_service_one_json" {
  template = file("task_definition_service_one.json")

  vars = {
    CONSUL_HOST   = aws_instance.consul_instance.private_dns
    CONSUL_PORT   = var.consul_port
    MONGO_HOST    = aws_docdb_cluster_instance.cluster_instances.endpoint
    MONGO_DB      = var.docdb_db
    MONGO_USER    = var.docdb_username
    MONGO_PASS    = var.docdb_password
    LOGSTASH_HOST = aws_instance.logstash_instance.private_dns
    LOGSTASH_PORT = "5001"
    RABBIT_HOST = "b-a2d3c8ac-eebc-43d5-aa2b-9b917560c582.mq.us-east-1.amazonaws.com"
    RABBIT_USER = "allianz_user_mq"
    RABBIT_PASS = "80EF9A1A04CED5D79F7D161A6039ACF14FA505EEE3EE728248710C674EDC1E13"
  }
}


##############################################################
# AWS ECS-SERVICE
##############################################################

resource "aws_ecs_service" "allianz-service-one-service" {
  cluster         = aws_ecs_cluster.cluster.id                              # ecs cluster id
  desired_count   = 1                                                       # no of task running
  launch_type     = "FARGATE"                                                   # Cluster type ECS OR FARGATE
  name            = "allianz-service-one-service"                           # Name of service
  task_definition = aws_ecs_task_definition.task_definition_service_one.arn # Attaching Task to service

 network_configuration {
   security_groups  = [aws_security_group.sg-ec2-ecs.id]
   subnets          = [module.vpc.private_subnets[0]]
   assign_public_ip = false
 }

  load_balancer {
    container_name   = "allianz-service-one" #"container_${var.component}_${var.environment}"
    container_port   = "8082"
    target_group_arn = aws_alb_target_group.service-one-public.arn # attaching load_balancer target group to ecs
  }
  depends_on = [aws_security_group.sg-ec2-ecs, time_sleep.wait_120_seconds]
}


### Fargate
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "service-one-ecsTaskExecutionRole"
 
  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "ecs-tasks.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}
 
resource "aws_iam_role_policy_attachment" "ecs-task-execution-role-policy-attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
resource "aws_iam_role" "ecs_task_role" {
  name = "service-one-ecsTaskRole"
 
  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "ecs-tasks.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}
 
resource "aws_iam_policy" "dynamodb" {
  name        = "service-one-task-policy-dynamodb"
  description = "Policy that allows access to DynamoDB"
 
 policy = <<EOF
{
   "Version": "2012-10-17",
   "Statement": [
       {
           "Effect": "Allow",
           "Action": [
               "dynamodb:CreateTable",
               "dynamodb:UpdateTimeToLive",
               "dynamodb:PutItem",
               "dynamodb:DescribeTable",
               "dynamodb:ListTables",
               "dynamodb:DeleteItem",
               "dynamodb:GetItem",
               "dynamodb:Scan",
               "dynamodb:Query",
               "dynamodb:UpdateItem",
               "dynamodb:UpdateTable"
           ],
           "Resource": "*"
       }
   ]
}
EOF
}
 
resource "aws_iam_role_policy_attachment" "ecs-task-role-policy-attachment" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = aws_iam_policy.dynamodb.arn
}

resource "time_sleep" "wait_120_seconds" {
  depends_on = [aws_db_instance.allianz_mysql, aws_docdb_cluster.docdb_cluster]

  create_duration = "120s"
}

# This resource will create (at least) 30 seconds after null_resource.previous
resource "null_resource" "next" {
  depends_on = [time_sleep.wait_120_seconds]
}