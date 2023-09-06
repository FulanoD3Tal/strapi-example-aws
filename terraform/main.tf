terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.15.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}




# resource "aws_db_instance" "strapi_db" {
#   identifier        = "strapi"
#   instance_class    = "db.t3.micro"
#   allocated_storage = 5
#   engine            = "postgres"
#   engine_version    = "15.3"
#   username          = "strapi_db_admin"
#   db_name           = "strapi"
#   password          = var.db_password

#   db_subnet_group_name   = aws_db_subnet_group.strapi_db_snet_group.name
#   vpc_security_group_ids = [aws_security_group.strapi-rds-group.id]
#   publicly_accessible    = true
#   skip_final_snapshot    = true
#   tags = {
#     Name       = "Strapi Bucket"
#     Enviroment = "Dev"
#   }
# }

# output "rds_hostname" {
#   description = "RDS instance hostname"
#   value       = aws_db_instance.strapi_db.address
# }


# output "rds_username" {
#   description = "RDS instance root username"
#   value       = aws_db_instance.strapi_db.username
# }


