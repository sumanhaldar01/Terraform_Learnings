#!/bin/bash
sudo apt update
sudo apt install -y nginx
sudo systemctl start nginx
sudo systemctl enable nginx

echo "<h1> Hello,from Nginx! in EC2 Instance </h1>" | sudo tee /var/www/html/index.html # or > /var/www/html/index.html