variable "db_password" {
  type        = string
  description = "the rds instance admin password"
  sensitive   = true
}

variable "db_name" {
  type        = string
  description = "the name of the db"
}
variable "db_user_name" {
  type        = string
  description = "the name of the db user name"
}
variable "aws_region" {
  type        = string
  description = "the aws to deploy the infrastructure"
}

variable "ssh-location" {
  type        = string
  description = "location of the ssh public key to connect to ec2 instance"
}

variable "aws_access_key_id" {
  type      = string
  sensitive = true
}

variable "aws_access_secret" {
  type      = string
  sensitive = true
}
