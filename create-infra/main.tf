provider "aws" {
  region = var.aws_region
}

resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = var.aws_vpc_tag_name
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

resource "aws_subnet" "private" {
  count  = 2
  vpc_id = aws_vpc.main.id
  cidr_block = cidrsubnet("10.0.0.0/16", 8, count.index + 2)
  availability_zone = ["ap-southeast-1a", "ap-southeast-1b"][count.index] # Adjust zone
  tags = {
    Name = "terraform-private-${count.index}" # Adjust tags
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
    Name = "terraform-nat-gw" # Adjust tags
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
  tags = {
    Name = "terraform-private-rt" # Adjust route table
  }
}

resource "aws_route_table_association" "private" {
  count          = 2
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

resource "aws_security_group" "bastion_sg" {
  name = "bastion-sg" # Adjust sg name
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

resource "aws_security_group" "app_sg" {
  name = "app-sg" # Adjust sg name
  vpc_id = aws_vpc.main.id

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    security_groups = [aws_security_group.lb_sg.id]
  }

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "lb_sg" {
  name = "lb-sg" # Adjust lb name
  vpc_id = aws_vpc.main.id

  ingress {
    from_port = 80
    to_port   = 80
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

resource "aws_instance" "bastion" {
  ami = "ami-0b1e534a4ff9019e0" # Amazon Linux 2
  instance_type = "t2.micro" # Adjust instance type
  subnet_id = aws_subnet.public[0].id
  security_groups = [aws_security_group.bastion_sg.id]
  key_name = var.key_pair_name
  tags = {
    Name = "bastion-host" # Adjust tags
  }
}

resource "aws_launch_template" "app" {
  name_prefix = "your-app-" # Adjust template name
  image_id = "ami-0b1e534a4ff9019e0" # Adjust image id
  instance_type = "t2.micro" # Adjust instance type
  key_name = var.key_pair_name

  vpc_security_group_ids = [aws_security_group.app_sg.id]

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "your-app" # Adjust tags
    }
  }
}

resource "aws_lb" "app_lb" {
  name = "terraform-lb" # Adjust lb name
  internal           = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.lb_sg.id]
  subnets            = aws_subnet.public[*].id
}

resource "aws_lb_target_group" "app_tg" {
  name = "terraform-tg" # Adjust tg name
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

resource "aws_lb_listener" "app_listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}

resource "aws_autoscaling_group" "app_asg" {
  desired_capacity    = 2
  max_size            = 4
  min_size            = 1
  vpc_zone_identifier = aws_subnet.private[*].id
  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }
  target_group_arns = [aws_lb_target_group.app_tg.arn]
  health_check_type = "EC2"
  tag {
    key = "Name" # Adjust tags
    value = "your-app-instance" # Adjust tags
    propagate_at_launch = true
  }
}
