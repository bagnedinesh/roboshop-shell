#The frontend is the service in RoboShop to serve the web content over Nginx. This will have the webframe for the web application.
#This is a static content and to serve static content we need a web server. This server
#Developer has chosen Nginx as a web server and thus we will install Nginx Web Server

#variable
Script_Location=$(pwd)

#Install Nginx
yum install nginx -y

#Start & Enable Nginx service
systemctl enable nginx
systemctl start nginx

#Remove the default content that web server is serving.
rm -rf /usr/share/nginx/html*

#Download the frontend content
curl -o /tmp/frontend.zip https://roboshop.artifacts.s3.amazonaws.com/frontend.zip

#Extract the frontend content
cd /usr/share/nginx/html
unzip /tmp/frontend.zip

#Create Nginx Reverse Proxy Configuration
cp ${Script_Location}/files/ngin-roboshop.conf /etc/nginx/default.d/roboshop.conf

#Restart Nginx Service to load the changes of the configuration.
systemctl restart nginx