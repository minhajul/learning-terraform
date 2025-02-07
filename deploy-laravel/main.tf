terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.5.0"
}

provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "your_laravel_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = var.key_name
  vpc_security_group_ids = [aws_security_group.your_sg.id]

  user_data = <<-EOF
        #!/bin/bash
        apt-get update -y
        apt-get upgrade -y

        # Install PHP 8.4 and extensions
        add-apt-repository ppa:ondrej/php -y
        apt-get update -y
        apt-get install -y php8.4 php8.4-fpm php8.4-mbstring php8.4-xml php8.4-mysql php8.4-curl \
        php8.4-zip php8.4-gd php8.4-bcmath php8.4-redis php8.4-mysql mysql-server

        # Install Nginx
        apt-get install -y nginx

        # Install Supervisor
        apt-get install -y supervisor

        # Install other dependencies
        apt-get install -y git unzip curl

        # Install Composer
        curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

        # Set up project directory
        sudo mkdir -p /var/www/your-laravel-project
        sudo chown -R ubuntu:ubuntu /var/www/your-laravel-project

        # Clone Laravel project from GitHub
        cd /var/www/your-laravel-project
        git clone https://github.com/your-repo/your-laravel-project.git .
        composer install

        # Configure Nginx
        cat > /etc/nginx/sites-available/default <<'EOL'
        server {
            listen 80;
            server_name _;
            root /var/www/html/your-laravel-project/public;

            add_header X-Frame-Options "SAMEORIGIN";
            add_header X-Content-Type-Options "nosniff";

            index index.php;

            charset utf-8;

            location / {
                try_files $uri $uri/ /index.php?$query_string;
            }

            location ~ \.php$ {
                fastcgi_pass unix:/run/php/php8.4-fpm.sock;
                fastcgi_param SCRIPT_FILENAME $realpath_root$fastcgi_script_name;
                include fastcgi_params;
            }

            location ~ /\.(?!well-known).* {
                deny all;
            }
        }
        EOL

        ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/
        rm /etc/nginx/sites-enabled/default

        # Set permissions
        sudo chown -R www-data:www-data /var/www/your-laravel-project
        sudo chmod -R 775 /var/www/your-laravel-project/storage /var/www/your-laravel-project/bootstrap/cache

        # Configure Supervisor
        cat > /etc/supervisor/conf.d/laravel-worker.conf <<'EOL'
        [program:laravel-worker]
        process_name=%(program_name)s_%(process_num)02d
        command=php /var/www/html/your-laravel-project/artisan queue:work --sleep=3 --tries=3
        autostart=true
        autorestart=true
        stopasgroup=true
        killasgroup=true
        user=www-data
        numprocs=1
        redirect_stderr=true
        stdout_logfile=/var/www/html/your-laravel-project/storage/logs/worker.log
        EOL

        # Restart services
        systemctl restart nginx
        systemctl restart php8.4-fpm
        supervisorctl reread
        supervisorctl update
        supervisorctl start laravel-worker:*

        EOF

  tags = {
    Name = "Laravel-Server"
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_security_group" "your_sg" {
  name        = "your-security-group" # Adjust the name
  description = "Allow HTTP, HTTPS, and SSH traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

variable "aws_region" {
  description = "AWS region"
  default     = "ap-southeast-1" # Adjust according to your need
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.micro" # Adjust according to your need
}

variable "key_name" {
  description = "Name of your SSH key pair"
  default     = "your-key-pair-name" # Give your key pair name
}

output "instance_public_ip" {
  value = aws_instance.your_laravel_server.public_ip
}