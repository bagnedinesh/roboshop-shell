#The frontend is the service in RoboShop to serve the web content over Nginx. This will have the webframe for the web application.
#This is a static content and to serve static content we need a web server. This server
#Developer has chosen Nginx as a web server and thus we will install Nginx Web Server

#variable
source common.sh

print_head "Install Nginx"
yum install nginx -y &>>${log}
status_check

print_head "Start & Enable Nginx service"
systemctl enable nginx &>>${log}
systemctl start nginx &>>${log}
status_check

print_head "Remove the default content that web server is serving."
rm -rf /usr/share/nginx/html/* &>>${log}
status_check

print_head "Download the frontend content"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${log}
status_check

print_head "Extract the frontend content"
cd /usr/share/nginx/html &>>{log}
unzip /tmp/frontend.zip &>>{log}
status_check

print_head "Create Nginx Reverse Proxy Configuration"
cp ${script_location}/files/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf &>>{log}
status_check

print_head "Restart Nginx Service to load the changes of the configuration."
systemctl restart nginx &>>{log}
status_check
