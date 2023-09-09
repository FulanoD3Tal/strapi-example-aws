data "aws_ami" "ubuntu_ami" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

resource "aws_security_group" "strapi_server_sg" {
  name        = "strapi_ec2_sg"
  description = "strapi ec2 server sg description"
  vpc_id      = aws_vpc.strapi_vpc.id
}

resource "aws_security_group_rule" "ssh" {
  description       = "ssh ingress"
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.strapi_server_sg.id
}
resource "aws_security_group_rule" "http" {
  description       = "http ingress"
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.strapi_server_sg.id
}
resource "aws_security_group_rule" "https" {
  description       = "https ingress"
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.strapi_server_sg.id
}
resource "aws_security_group_rule" "custom-strapi" {
  description       = "https ingress for strapi port"
  type              = "ingress"
  from_port         = 1337
  to_port           = 1337
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.strapi_server_sg.id
}

resource "aws_security_group_rule" "egress" {
  description       = "output trafic"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.strapi_server_sg.id
}

resource "aws_key_pair" "ssh_key_pair" {
  key_name   = "strapi_ssh_key"
  public_key = var.ssh-location
}


resource "aws_instance" "strapi_server" {
  ami                    = data.aws_ami.ubuntu_ami.id
  instance_type          = "t3.small"
  key_name               = aws_key_pair.ssh_key_pair.key_name
  subnet_id              = aws_subnet.public_subnet_1.id
  vpc_security_group_ids = [aws_security_group.strapi_server_sg.id]
  
  user_data = templatefile("init.tftpl", {
    rds_hostname      = "${aws_db_instance.strapi_db.address}",
    rds_db_name       = "${var.db_name}",
    rds_username      = "${var.db_user_name}",
    db_password       = "${var.db_password}",
    aws_region        = "${var.aws_region}",
    s3_name           = "${aws_s3_bucket.strapi_storage.bucket}",
    aws_access_key_id = "${var.aws_access_key_id}",
    aws_access_secret = "${var.aws_access_secret}",
  })
  tags = {
    name = "strapi"
  }
  depends_on = [aws_db_instance.strapi_db, aws_s3_bucket.strapi_storage]
}

resource "aws_eip" "strapi_eip" {
  instance = aws_instance.strapi_server.id
  domain   = "vpc"
}

output "strapi_server_dns" {
  value = aws_eip.strapi_eip.public_dns
}
output "strapi_server_ip" {
  value = aws_eip.strapi_eip.public_ip
}
