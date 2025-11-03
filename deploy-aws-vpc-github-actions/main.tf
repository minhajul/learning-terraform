terraform {
  backend "remote" {
    organization = "your-organisation" # Update this

    workspaces {
      name = "your-workspace" # Update this
    }
  }
}

provider "aws" {
  region = "ap-southeast-1" # Update this
}

data "http" "checkmyip" {
  url = "https://checkip.amazonaws.com"
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners = ["099720109477"] # Canonical official owner ID

  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0" # Use a more recent version

  name = "my-vpc"
  cidr = "10.0.0.0/16"

  azs = ["ap-southeast-1a"]
  public_subnets = ["10.0.1.0/24"]

  enable_dns_hostnames = true
  enable_dns_support   = true

  map_public_ip_on_launch = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

resource "aws_security_group" "your_sg" {
  name   = "your-sg"
  vpc_id = module.vpc.vpc_id

  ingress {
    description = "Allow SSH from the build runner"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.checkmyip.body)}/32"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ec2-sg"
  }
}

resource "aws_key_pair" "main" {
  key_name   = "personal-workspace-key"
  public_key = var.ssh_public_key
}

resource "aws_instance" "ec2" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  subnet_id     = module.vpc.public_subnets[0]
  key_name      = aws_key_pair.main.key_name

  vpc_security_group_ids = [aws_security_group.your_sg.id]

  tags = {
    Name = "public-ec2-instance"
  }
}