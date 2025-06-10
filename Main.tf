
provider "aws" {

  region = var.aws_region

}



# VPC

resource "aws_vpc" "main" {

  cidr_block = var.vpc_cidr

  enable_dns_support = true

  enable_dns_hostnames = true

  tags = { Name = "main-vpc" }

}



# Public Subnet

resource "aws_subnet" "public" {

  vpc_id = aws_vpc.main.id

  cidr_block = "var.public_subnet_cidr"

  map_public_ip_on_launch = true

  availability_zone = var.public_az

  tags = { Name = "public-subnet" }

}



# Private Subnet

resource "aws_subnet" "private" {

  vpc_id = aws_vpc.main.id

  cidr_block = "var.private_subnet_cidr"

  availability_zone = var.private_az

  tags = { Name = "private-subnet" }

}



# Internet Gateway

resource "aws_internet_gateway" "gw" {

  vpc_id = aws_vpc.main.id

  tags = { Name = "main-igw" }

}



# Route Table

resource "aws_route_table" "public" {

  vpc_id = aws_vpc.main.id

  route {

    cidr_block = "0.0.0.0/0"

    gateway_id = aws_internet_gateway.gw.id

  }



  tags = { Name = "public-rt" }

}



resource "aws_route_table_association" "public_assoc" {

  subnet_id = aws_subnet.public.id

  route_table_id = aws_route_table.public.id

}



# Security Group for web server

resource "aws_security_group" "web_sg" {

  name = "web-sg"

  description = "Allow HTTP and HTTPS"

  vpc_id = aws_vpc.main.id



  ingress {

    from_port = 80

    to_port = 80

    protocol = "tcp"

    cidr_blocks = ["0.0.0.0/0"]

  }





  ingress {

    from_port = 443

    to_port = 443

    protocol = "tcp"

    cidr_blocks = ["0.0.0.0/0"]

  }



  egress {

    from_port = 0

    to_port = 0

    protocol = "-1"

    cidr_blocks = ["0.0.0.0/0"]

  }



  tags = { Name = "web-sg" }

}



# EC2 Instance

resource "aws_instance" "web" {

  ami = var.ami_id

  instance_type = var.instance_type



  subnet_id = aws_subnet.public.id

  associate_public_ip_address = true

  vpc_security_group_ids = [aws_security_group.web_sg.id]

  key_name = var.key_name = "mj_awskey"

usr_data = file("usrdata.sh")

  tags = {
    Name = "WebServer"
  }
}
