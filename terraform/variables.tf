variable "db_password" {
  type        = string
  description = "the rds instance admin password"
  sensitive   = true
}

variable "aws_region" {
  type = string
  description = "the aws to deploy the infrastructure"
}

variable "ssh-location" {
  type = string
  description = "location of the ssh public key to connect to ec2 instance"
}
