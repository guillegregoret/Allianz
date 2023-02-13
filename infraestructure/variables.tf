
variable "domain_name" {
  type        = string
  description = "The domain name for the website."
  default     = "allianz.gregoret.com.ar"
}

variable "bucket_name" {
  type        = string
  description = "The name of the bucket without the www. prefix. Normally domain_name."
  default     = "allianz.gregoret.com.ar"
}

####RDS####

variable "rds_username" {
  type    = string
  default = "rdsuser"
}
variable "rds_password" {
  type    = string
  default = "Passs_w0rd"
}
variable "rds_db_name" {
  type    = string
  default = "allianz"
}
variable "consul_port" {
  type    = string
  default = "8500"
}
variable "docdb_username" {
  type    = string
  default = "docdbuser"
}
variable "docdb_password" {
  type    = string
  default = "Passs_w0rd"
}
variable "docdb_db" {
  type    = string
  default = "allianz"
}