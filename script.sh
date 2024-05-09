#!/bin/bash
echo "*** Installing Nginx"
sudo apt update -y
sudo apt install nginx -y
sudo apt install apache2 -y
cd /var/www/html/
rm -rf index.nginx-debian.html
rm -rf index.html
cd /var/www/html/
echo "<center><h1>Hello World !</center> </h1> <br> This is created by terraform !" > /var/www/html/index.html
wget https://www.free-css.com/assets/files/free-css-templates/download/page296/listrace.zip
sudo apt install unzip
unzip listrace.zip
rm -rf listrace.zip