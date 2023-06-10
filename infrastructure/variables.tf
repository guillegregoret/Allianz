variable "domain_name" {
  type        = string
  description = "The domain name for the website."
}

variable "bucket_name" {
  type        = string
  description = "The name of the bucket without the www. prefix. Normally domain_name."
}
variable "rds_username" {
  type = string
}
variable "rds_password" {
  type = string
}
variable "rds_db_name" {
  type = string
}
variable "consul_port" {
  type = string
}
variable "docdb_username" {
  type = string
}
variable "docdb_password" {
  type = string
}
variable "docdb_db" {
  type = string
}
variable "opensearch_user" {
  type = string
}
variable "opensearch_password" {
  type = string
}
variable "logstash_port" {
  type = string
}
variable "rabbit_host" {
  type = string
}
variable "rabbit_user" {
  type = string
}
variable "rabbit_pass" {
  type = string
}