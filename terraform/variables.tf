variable "db_password" {
  type        = string
  description = "the rds instance admin password"
  sensitive   = true
}

variable "db_name" {
  type = string
  description = "the name of the db"
}
variable "db_user_name" {
  type = string
  description = "the name of the db user name"
}
