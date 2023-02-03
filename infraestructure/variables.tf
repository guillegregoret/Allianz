variable "app_count" {
  type    = number
  default = 1
}
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


variable "cognito_domain" {
  type    = string
  default = "allianz-dev"
}


variable "common_tags" {
  description = "Common tags you want applied to all components."
  default     = ""
}

variable "db_password" {
  description = "RDS root user password"
  type        = string
  sensitive   = true
  default     = "Pavilionw5520la"
}

####RDS####
variable "env" {
  description = "Current environment"
  type        = string
  default     = "staging"
}

variable "db_name" {
  description = "Postgres Database Name"
  type        = string
  default     = "allianz"
}

variable "owner" {
  description = "Stack owner"
  type        = string
  default     = "allianz"
}

variable "allowed_account_ids" {
  description = "AWS account ids"
  type        = list(string)
  default     = ["123456789012"]
}

variable "project" {
  description = "Project"
  type        = string
  default     = "allianz"
}

variable "region" {
  description = "A list of availability zones in the region"
  type        = string
  default     = "us-east-1"
}

variable "storage_encrypted" {
  description = "Storage encryption"
  type        = bool
  default     = true
}

variable "multi_az" {
  description = "Multi AZ mode for db"
  type        = bool
  default     = false
}

variable "database_master_user" {
  description = "Db master user"
  type        = string
  default     = "root"
}

variable "database_master_password" {
  description = "Db master password"
  type        = string
  default     = "MyAweSomePassWord"
}

variable "database_user" {
  description = "Db user"
  type        = string
  default     = "rdsdbuser"
}

variable "database_password" {
  description = "Db password"
  type        = string
  default     = "MyP@ssw0rdIsNotSecureAtAll"
}
####RDS####

##Cloudflare##
variable "cloudflare_api_token" {
  type        = string
  description = "CloudFlare access token"
  default     = "_lrUV3KgO8IKjhAz7Lz-q2F0NDuRoVwSMlVCJb9i"
}

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