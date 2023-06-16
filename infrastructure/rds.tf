################################################################################
# RDS
################################################################################
resource "aws_db_subnet_group" "rds-private-subnet" {
  name       = "rds-private-subnet-group"
  subnet_ids = [module.vpc.private_subnets[0], module.vpc.private_subnets[1]]
}

resource "aws_security_group" "rds-sg" {
  name   = "my-rds-sg"
  vpc_id = module.vpc.vpc_id

}

# Ingress Security Port 3306
resource "aws_security_group_rule" "mysql_inbound_access" {
  from_port         = 3306
  protocol          = "tcp"
  security_group_id = aws_security_group.rds-sg.id
  to_port           = 3306
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_db_instance" "mysql" {
  allocated_storage           = 20
  storage_type                = "gp3"
  engine                      = "mysql"
  engine_version              = "8.0.28"
  instance_class              = "db.t3.medium"
  identifier                  = var.rds_db_name
  db_name                     = var.rds_db_name
  username                    = var.rds_username
  password                    = var.rds_password
  parameter_group_name        = "default.mysql8.0"
  db_subnet_group_name        = aws_db_subnet_group.rds-private-subnet.name
  vpc_security_group_ids      = ["${aws_security_group.rds-sg.id}"]
  allow_major_version_upgrade = true
  auto_minor_version_upgrade  = true
  backup_retention_period     = 1
  backup_window               = "22:00-23:00"
  maintenance_window          = "Sat:00:00-Sat:03:00"
  multi_az                    = false
  skip_final_snapshot         = true
  apply_immediately           = true

  blue_green_update {
    enabled = true
  }
}