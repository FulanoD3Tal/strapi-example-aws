terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.15.0"
    }
  }
}

data "aws_availability_zones" "available" {

}

provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.1"

  name                 = "strapi_vpc"
  cidr                 = "10.0.0.0/16"
  azs                  = data.aws_availability_zones.available.names
  public_subnets       = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  enable_dns_hostnames = true
  enable_dns_support   = true
}

resource "aws_db_subnet_group" "strapi_db_snet_group" {
  name       = "strapi_db_group"
  subnet_ids = module.vpc.public_subnets
  tags = {
    Name = "Strapi"
  }
}

resource "aws_security_group" "strapi-rds-group" {
  name   = "strapi-rds-security-group"
  vpc_id = module.vpc.vpc_id
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "Strapi"
  }
}


resource "aws_db_instance" "strapi_db" {
  identifier        = "strapi"
  instance_class    = "db.t3.micro"
  allocated_storage = 5
  engine            = "postgres"
  engine_version    = "15.3"
  username          = "strapi_db_admin"
  db_name           = "strapi"
  password          = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.strapi_db_snet_group.name
  vpc_security_group_ids = [aws_security_group.strapi-rds-group.id]
  publicly_accessible    = true
  skip_final_snapshot    = true
  tags = {
    Name       = "Strapi Bucket"
    Enviroment = "Dev"
  }
}

output "rds_hostname" {
  description = "RDS instance hostname"
  value       = aws_db_instance.strapi_db.address
}


output "rds_username" {
  description = "RDS instance root username"
  value       = aws_db_instance.strapi_db.username
}


