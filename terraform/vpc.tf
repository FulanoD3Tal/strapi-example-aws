data "aws_availability_zones" "available" {

}

resource "aws_vpc" "strapi_vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    env = "strapi"
  }
}

resource "aws_internet_gateway" "strapi_vpc_igw" {
  vpc_id = aws_vpc.strapi_vpc.id
}

resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.strapi_vpc.id
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[0]
  cidr_block              = "10.0.101.0/24"
  tags = {
    name = "public-subnet"
  }
}
resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.strapi_vpc.id
  availability_zone = data.aws_availability_zones.available.names[0]
  cidr_block        = "10.0.1.0/24"
}
resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.strapi_vpc.id
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[1]
  cidr_block              = "10.0.102.0/24"
  tags = {
    name = "public-subnet"
  }
}
resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.strapi_vpc.id
  availability_zone = data.aws_availability_zones.available.names[1]
  cidr_block        = "10.0.2.0/24"
}

resource "aws_route_table" "public_table" {
  vpc_id = aws_vpc.strapi_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.strapi_vpc_igw.id
  }
}
resource "aws_route_table" "private_table" {
  vpc_id = aws_vpc.strapi_vpc.id
  route {
    cidr_block = "10.0.0.0/16"
    gateway_id = "local"
  }
}

resource "aws_route_table_association" "public_subnet_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_table.id
}
resource "aws_route_table_association" "public_subnet_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_table.id
}
resource "aws_route_table_association" "private_subnet_1" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_table.id
}
resource "aws_route_table_association" "private_subnet_2" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_table.id
}
