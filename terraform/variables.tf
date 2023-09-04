variable "db_password" {
  type        = string
  description = "the rds instance admin password"
  sensitive   = true
}
