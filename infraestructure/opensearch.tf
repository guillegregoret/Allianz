resource "aws_opensearch_domain" "allianz_opensearch" {
  domain_name    = "opensearch-allianz"
  engine_version = "OpenSearch_2.3"

  cluster_config {
    instance_type = "t3.small.search"
  }
    encrypt_at_rest {
    enabled = true
  }

  domain_endpoint_options {
    enforce_https       = true
    tls_security_policy = "Policy-Min-TLS-1-2-2019-07"
  }
    node_to_node_encryption {
    enabled = true
  }
  advanced_security_options {
    enabled                        = true
    anonymous_auth_enabled         = false
    internal_user_database_enabled = true
    master_user_options {
      master_user_name     = "allianz-os"
      master_user_password = "3EF92b15150894018E05-747d4CFAAeB0"
    }
  }
    ebs_options {
    ebs_enabled = true
    volume_size = 10
  }

}