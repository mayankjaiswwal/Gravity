#!/bin/bash
sudo yum update -y
sudo yum install -y nginx
sudo systemctl enable nginx
sudo systemctl start nginx
echo "<h1>Welcome to CI/CD Deployment</h1>" > /usr/share/nginx/html/index.html
