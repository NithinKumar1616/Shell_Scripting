#! /bin/bash

set -x

set -e

set -o

sudo su ~

cd /

#Install Nginx

dnf install nginx -y 

#Enable nginx

systemctl enable nginx

#Start nginx

systemctl start nginx

#Remove the default content that web server is serving.

rm -rf /usr/share/nginx/html/*

#Download the frontend content

curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip

#Extract the frontend content.

cd /usr/share/nginx/html

unzip /tmp/frontend.zip

#Create Nginx Reverse Proxy Configuration.

vim /etc/nginx/default.d/expense.conf

#Add the following content

proxy_http_version 1.1;

location /api/ { proxy_pass http://localhost:8080/; }

location /health {
  stub_status on;
  access_log off;
}

#Restart Nginx Service to load the changes of the configuration.

systemctl restart nginx