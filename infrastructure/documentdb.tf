# Security Group DocumentDB
resource "aws_security_group" "docdb-sg" {
  name   = "my-docdb-sg"
  vpc_id = module.vpc.vpc_id
}

# Ingress Security Port 27017
resource "aws_security_group_rule" "docdb_inbound_access" {
  from_port         = 27017
  protocol          = "tcp"
  security_group_id = aws_security_group.docdb-sg.id
  to_port           = 27017
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
}

# DocDB Cluster Instance
resource "aws_docdb_cluster_instance" "cluster_instances" {
  identifier         = "docdb-cluster-${var.project_name}"
  cluster_identifier = aws_docdb_cluster.docdb_cluster.id
  instance_class     = "db.t3.medium"
  apply_immediately  = true
  lifecycle {
    ignore_changes = [identifier]
  }
}

# DocDB Cluster
resource "aws_docdb_cluster" "docdb_cluster" {
  cluster_identifier              = "docdb-cluster-${var.project_name}"
  availability_zones              = ["us-east-1a"]
  master_username                 = var.docdb_username
  master_password                 = var.docdb_password
  db_cluster_parameter_group_name = aws_docdb_cluster_parameter_group.docdb-paramgroup.id
  vpc_security_group_ids          = ["${aws_security_group.docdb-sg.id}"]
  db_subnet_group_name            = aws_docdb_subnet_group.docdb_subnetgroup.name
  skip_final_snapshot             = true
  apply_immediately               = true
  lifecycle {
    ignore_changes = [availability_zones]
  }

}

# DocDB Parameter Group
resource "aws_docdb_cluster_parameter_group" "docdb-paramgroup" {
  family      = "docdb5.0"
  name        = "docdb-paramgroup"
  description = "docdb cluster parameter group"

  parameter {
    name  = "tls"
    value = "disabled"
  }
  parameter {
    name  = "ttl_monitor"
    value = "disabled"
  }
}

resource "aws_docdb_subnet_group" "docdb_subnetgroup" {
  name       = "${var.project_name}-docdb-subnetgroup"
  subnet_ids = [module.vpc.private_subnets[0], module.vpc.private_subnets[1]]
}