terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.40"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 3.0"
    }
  }
}

## Locals

locals {
  name     = var.project_name
  rds_name = "${var.project_name}_rds"
  region   = "us-east-1"
  tags = {
    Owner       = "${var.project_name}"
    Environment = "staging"
  }
}
##

provider "aws" {
  region  = "us-east-1"
  profile = "gregoretcorp"
}

provider "aws" {
  alias   = "acm_provider"
  region  = "us-east-1"
  profile = "gregoretcorp"
}

# VPC Config
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 2"

  name = local.name
  cidr = "10.99.0.0/18"

  azs             = ["${local.region}a", "${local.region}b", "${local.region}c"]
  public_subnets  = ["10.99.0.0/24", "10.99.1.0/24", "10.99.2.0/24"]
  private_subnets = ["10.99.3.0/24", "10.99.4.0/24", "10.99.5.0/24"]
  #database_subnets = ["10.99.7.0/24", "10.99.8.0/24", "10.99.9.0/24"]

  create_database_subnet_group = false
  enable_dns_hostnames         = true

  enable_nat_gateway  = true
  single_nat_gateway  = true
  reuse_nat_ips       = true                 # <= Skip creation of EIPs for the NAT Gateways
  external_nat_ip_ids = aws_eip.eip_nat.*.id # <= IPs specified here as input to the module

}

#Elastic IP for NAT Gateway
resource "aws_eip" "eip_nat" {
  vpc = true
}

#Security Groups
module "security_group_rds" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4"

  name        = local.name
  description = "Complete PostgreSQL security group"
  vpc_id      = module.vpc.vpc_id

  # ingress
  ingress_with_cidr_blocks = [
    {
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      description = "PostgreSQL access from within VPC"
      cidr_blocks = module.vpc.vpc_cidr_block
    },
  ]

  tags = local.tags
}

resource "aws_security_group" "public" {
  name        = "Allow public HTTP/HTTPS ALB"
  description = "Public internet access"
  vpc_id      = module.vpc.vpc_id

}

resource "aws_security_group_rule" "public_out" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.public.id
}

resource "aws_security_group" "private_alb" {
  name = "Allow private traffic ALB"
  #description = "Public internet access"
  vpc_id = module.vpc.vpc_id

}

resource "aws_security_group_rule" "private_network_rule" {
  type        = "ingress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["10.99.0.0/18"]

  security_group_id = aws_security_group.private_alb.id
}

resource "aws_security_group_rule" "public_in_https_svc_one" {
  type              = "ingress"
  from_port         = 8082
  to_port           = 8082
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.public.id
}

resource "aws_security_group_rule" "public_in_https_svc_two" {
  type              = "ingress"
  from_port         = 8084
  to_port           = 8084
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.public.id
}

resource "aws_security_group" "sg-ec2-ecs" {
  name        = "ec2-ecs instance"
  description = "Public internet access"
  vpc_id      = module.vpc.vpc_id

}

resource "aws_security_group_rule" "public_out_ec2_ecs" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.sg-ec2-ecs.id
}

resource "aws_security_group_rule" "private_in" {
  type        = "ingress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["10.99.0.0/18"]

  security_group_id = aws_security_group.sg-ec2-ecs.id
}
resource "aws_key_pair" "terraform_ec2_key" {
  key_name   = "terraform_ec2_key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC2/QlUK8DpNUyIXHMVtfH6XxesN0b9pH0ooPTuFRuMNXn6vdGWkG2s3sIby4A6yVTTkmwQ47YhTc/B9/B+Ui4mAZG5l2xTOyZp/mPgXJZWNMfHOMIu6tWU/PkahhhICDUVfnPcLSa8rT9ywi5w5nn2nKyujbpwMTwTJMKH6HR0OyT37g2FyPnrnVXW6LRIelGYGWWWkCAqNV33Wo9TV2UqSzA5kRW2pWb38iszWaYvdDhL82MffJpJeJ1xUrna4SmeRqyuoiH9E6WPCn3wx++rNoyqLpuwyvEvJncN6UHGyTOrUfHmoK8u80dHHJQ8cenWWIFugfFR6bmo8xowqvi/ ggregoret"
}