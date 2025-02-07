provider "aws" {
  region = "ap-southeast-1" # Change this to your preferred region
}

resource "aws_security_group" "your_sg" {
  name        = "your-security-group"
  description = "Allow inbound traffic"

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Restrict this to your IP for security
  }

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port   = 443
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

resource "aws_instance" "your_server" {
  ami = "ami-0c55b159cbfafe1f0" # Change to your region-specific Amazon Linux 2 or Ubuntu AMI
  instance_type = "t3.micro" # Adjust according to your need
  key_name = "your-key-pair" # Replace with your key pair name
  security_groups = [aws_security_group.your_sg.name]

  user_data = <<-EOF
    #!/bin/bash
    sudo apt update -y
    sudo apt install -y nginx supervisor git unzip curl php8.4 php8.4-cli php8.4-mbstring php8.4-xml php8.4-bcmath php8.4-curl php8.4-zip php8.4-tokenizer php8.4-mysql composer mysql-server

    # Start and enable services
    sudo systemctl enable nginx
    sudo systemctl start nginx
    sudo systemctl enable supervisor
    sudo systemctl start supervisor
    sudo systemctl enable mysql
    sudo systemctl start mysql

    # Set up Laravel directory
    sudo mkdir -p /var/www/laravel
    sudo chown -R ubuntu:ubuntu /var/www/laravel

    # Clone Laravel project from GitHub
    cd /var/www/laravel
    git clone https://github.com/your-repo/your-laravel-project.git .
    composer install

    # Set permissions
    sudo chown -R www-data:www-data /var/www/your-laravel-project
    sudo chmod -R 775 /var/www/your-laravel-project/storage /var/www/your-laravel-project/bootstrap/cache
  EOF

  tags = {
    Name = "Laravel-EC2"
  }
}
