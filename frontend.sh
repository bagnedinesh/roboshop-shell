#The frontend is the service in RoboShop to serve the web content over Nginx. This will have the webframe for the web application.
#This is a static content and to serve static content we need a web server. This server
#Developer has chosen Nginx as a web server and thus we will install Nginx Web Server

#variable
source common.sh

echo -e "\e[35m Install Nginx \e[0m"
yum install nginx -y &>>${log}
status_check

echo -e "\e[35m Start & Enable Nginx service \e[0m"
systemctl enable nginx &>>${log}
systemctl start nginx &>>${log}
status_check

echo -e "\e[35m Remove the default content that web server is serving. \e[0m"
rm -rf /usr/share/nginx/html/* &>>${log}
status_check

echo -e "\e[35m Download the frontend content \e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${log}
status_check

echo -e "\e[35m Extract the frontend content \e[0m"
cd /usr/share/nginx/html &>>{log}
unzip /tmp/frontend.zip &>>{log}
status_check

echo -e "\e[35m Create Nginx Reverse Proxy Configuration \e[0m"
cp ${Script_Location}/files/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf &>>{log}
status_check

echo -e "\e[35m Restart Nginx Service to load the changes of the configuration. \e[0m"
systemctl restart nginx &>>{log}
status_check
