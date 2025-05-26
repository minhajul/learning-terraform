#!/bin/bash

# Update system
apt-get update -y

# Install PHP 8.4
apt-get install -y software-properties-common
add-apt-repository ppa:ondrej/php -y
apt-get update -y
apt-get install -y php8.4 php8.4-fpm php8.4-mysql php8.4-mbstring php8.4-xml php8.4-bcmath php8.4-curl php8.4-zip php8.4-gd

# Install Nginx
apt-get install -y nginx

# Install MySQL
debconf-set-selections <<< 'mysql-server mysql-server/root_password password your_secure_password'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password your_secure_password'
apt-get install -y mysql-server

# Install Supervisor
apt-get install -y supervisor

# Install Composer
curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Configure MySQL
mysql -uroot -pyour_secure_password -e "CREATE DATABASE laravel_db;"
mysql -uroot -pyour_secure_password -e "CREATE USER 'laravel_user'@'localhost' IDENTIFIED BY 'laravel_password';"
mysql -uroot -pyour_secure_password -e "GRANT ALL PRIVILEGES ON laravel_db.* TO 'laravel_user'@'localhost';"
mysql -uroot -pyour_secure_password -e "FLUSH PRIVILEGES;"

# Configure PHP-FPM
sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/' /etc/php/8.4/fpm/php.ini
systemctl restart php8.4-fpm

# Configure Nginx
cat > /etc/nginx/sites-available/laravel << 'EOL'
server {
    listen 80;
    server_name _;
    root /var/www/laravel/public;

    add_header X-Frame-Options "SAMEORIGIN";
    add_header X-Content-Type-Options "nosniff";

    index index.php;

    charset utf-8;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location = /favicon.ico { access_log off; log_not_found off; }
    location = /robots.txt  { access_log off; log_not_found off; }

    error_page 404 /index.php;

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

ln -s /etc/nginx/sites-available/laravel /etc/nginx/sites-enabled/
rm /etc/nginx/sites-enabled/default
systemctl restart nginx

# Create Laravel directory and set permissions
mkdir -p /var/www/laravel
chown -R www-data:www-data /var/www/laravel
chmod -R 775 /var/www/laravel/storage
chmod -R 775 /var/www/laravel/bootstrap/cache

# Enable services
systemctl enable nginx
systemctl enable mysql
systemctl enable php8.4-fpm
systemctl enable supervisor

# Start services
systemctl start nginx
systemctl start mysql
systemctl start php8.4-fpm
systemctl start supervisor