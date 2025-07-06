#!/bin/bash

sudo apt update -y
sudo apt install nginx -y
sudo mkdir -p /var/www/html
echo '<html><body><h1>Welcome</h1></body></html>' | sudo tee /var/www/html/index.html
sudo chown -R www-data:www-data /var/www/html
sudo systemctl start nginx
sudo systemctl enable nginx
