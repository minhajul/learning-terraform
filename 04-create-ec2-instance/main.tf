provider "aws" {
  region = var.aws_region
}

# You need to create key pair first
resource "aws_key_pair" "web_key" {
  key_name   = "web_key"
  public_key = file("~/.ssh/web_key.pub")
}

resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = var.vpc_tag_name
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = var.aws_internet_gateway_tag_name
  }
}

resource "aws_subnet" "public" {
  count                   = 2
  vpc_id                  = aws_vpc.main.id
  cidr_block = cidrsubnet("10.0.0.0/16", 8, count.index)
  map_public_ip_on_launch = true
  availability_zone = ["ap-southeast-1a", "ap-southeast-1b"][count.index] # Adjust zone
  tags = {
    Name = "terraform-public-${count.index}" # Adjust tags
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "terraform-public-rt" # Adjust route tables
  }
}

resource "aws_route_table_association" "public" {
  count          = 2
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_eip" "nat" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id
  tags = {
    Name = var.aws_nat_gateway_name
  }
}

resource "aws_security_group" "app_sg" {
  name = var.aws_security_group_name
  description = "Allow SSH"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web_server" {
  ami = "ami-0b1e534a4ff9019e0" # Amazon Linux 2
  instance_type = "t2.micro" # Adjust instance type
  subnet_id = aws_subnet.public[0].id
  security_groups = [aws_security_group.app_sg.id]

  key_name  = var.key_pair_name
  public_key = file("~/.ssh/web_key.pub")

  tags = {
    Name = "app-web_server" # Adjust tags
  }
  user_data = <<-EOF
      #!/bin/bash
      apt-get update
      apt-get install -y nginx
    EOF
}
