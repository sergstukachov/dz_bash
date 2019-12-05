#!/bin/bash
sudo apt-get update -y
sudo apt-get install nginx -y
sudo apt-get install mysql-server -y
sudo apt-get install php7.2-fpm php7.2-mysql -y
sudo sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 256M/g; s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g; s/memory_limit = 128M/memory_limit = 256M/g' /etc/php/7.2/fpm/php.ini
echo "SERVER_IP :"
  read SERVER_IP

sudo sed -i 's/ index index.html index.htm index.nginx-debian.html/index index.php index.html index.htm index.nginx-debian.html/g; s/location \/ {
        try_files $uri $uri\/ =404;
    }
}/location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php7.0-fpm.sock;
    }

    location ~ \/\.ht {
        deny all;
    }
}/g; s/server_name _;/server_name $SERVER_IP;/g' /etc/nginx/sites-available/default
sudo apt install curl 
curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer
cd /var/www/html
composer create-project laravel/laravel MyProject --prefer-dist 
sudo chown -R www-data:www-data /var/www/html/MyProject/
sudo chmod -R 755 /var/www/html/MyProject/
echo "SERVER_NAME :"
  read SERVER_NAME
sudo echo "server {
  >     listen 80;
  >     listen [::]:80;
  >     root /var/www/html/MyProject/public;
  >     index  index.php index.html index.htm;
  >     server_name  $SERVER_NAME;
  > 
  >     location / {
  >         try_files $uri $uri/ /index.php?$query_string;        
  >     }
  > 
  >   
  >     location ~ \.php$ {
  >        include snippets/fastcgi-php.conf;
  >        fastcgi_pass             unix:/var/run/php/php7.2-fpm.sock;
  >        fastcgi_param   SCRIPT_FILENAME $document_root$fastcgi_script_name;
  >     }
  > 
  > }">/etc/nginx/sites-available/laravel

sudo ln -s /etc/nginx/sites-available/laravel /etc/nginx/sites-enabled/

sudo systemctl restart nginx.service 
