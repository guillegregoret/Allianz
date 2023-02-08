resource "aws_security_group" "docdb-sg" {
  name   = "my-docdb-sg"
  vpc_id = module.vpc.vpc_id

}

# Ingress Security Port 3306
resource "aws_security_group_rule" "docdb_inbound_access" {
  from_port         = 27017
  protocol          = "tcp"
  security_group_id = aws_security_group.docdb-sg.id
  to_port           = 27017
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_docdb_cluster_instance" "cluster_instances" {
  identifier         = "docdb-cluster-allianz"
  cluster_identifier = aws_docdb_cluster.docdb_cluster.id
  instance_class     = "db.t3.medium"

  lifecycle {
    ignore_changes = [identifier]
  }
}

resource "aws_docdb_cluster" "docdb_cluster" {
  cluster_identifier              = "docdb-cluster-allianz"
  availability_zones              = ["us-east-1a"]
  master_username                 = var.docdb_username
  master_password                 = var.docdb_password
  db_cluster_parameter_group_name = aws_docdb_cluster_parameter_group.docdb-paramgroup-allianz.id
  vpc_security_group_ids          = ["${aws_security_group.docdb-sg.id}"]
  db_subnet_group_name    = "${aws_docdb_subnet_group.docdb_subnetgroup.name}"

  lifecycle {
    ignore_changes = [availability_zones]
  }

}

resource "aws_docdb_cluster_parameter_group" "docdb-paramgroup-allianz" {
  family      = "docdb4.0"
  name        = "docdb-paramgroup-allianz"
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
  name       = "allianz-docdb-subnetgroup"
  subnet_ids = [module.vpc.private_subnets[0],module.vpc.private_subnets[1]]
}