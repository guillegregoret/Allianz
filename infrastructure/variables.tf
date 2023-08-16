variable "domain_name" {
  type = string
}
variable "project_name" {
  type = string
}
variable "bucket_name" {
  type = string
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
variable "opensearch_url" {
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
variable "service_one_docker_image" {
  type = string
}
variable "service_two_docker_image" {
  type = string
}
variable "ecs_cluster_name" {
  type = string
}
variable "cloudflare_api_token" {
  type = string
}
variable "cloudflare_zone_id" {
  type = string
}
variable "environment" {
  type = string
}