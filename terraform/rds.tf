resource "aws_security_group" "strapi_rds_sg" {
  name        = "strapi-rds-sg"
  description = "strapi rds server security group"
  vpc_id      = aws_vpc.strapi_vpc.id
  tags = {
    Name = "strapi"
  }
  ingress {
    description     = "rds port ingress"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.strapi_server_sg.id]
  }
}

resource "aws_db_subnet_group" "strapi_rds_subnet_group" {
  name        = "strapi-rds-subnet-group"
  description = "RDS subnet group for tutorial"

  subnet_ids = [aws_subnet.private_subnet_1, aws_subnet.private_subnet_2]
}


resource "aws_db_instance" "strapi_db" {
  identifier        = "strapi"
  instance_class    = "db.t3.micro"
  allocated_storage = 5
  engine            = "postgres"
  engine_version    = "15.3"
  username          = var.db_user_name
  db_name           = var.db_name
  password          = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.strapi_rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.strapi_rds_sg.id]
  publicly_accessible    = true
  skip_final_snapshot    = true
  tags = {
    Name       = "Strapi DB"
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
