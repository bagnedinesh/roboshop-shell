#Catalogue is a microservice that is responsible for serving the list of items
# that displays in roboshop application.
script_location=$(pwd)
#Setup NodeJS repos
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

#Install NodeJS
yum install nodejs -y

#Add application User
useradd roboshop

#setup an app directory
mkdir /app

#Download the application code
curl -L -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
cd /app
unzip /tmp/catalogue.zip

# download the dependencies
cd /app
npm install

#Setup SystemD Catalogue Service
cp ${script_location}/files/catalogue.service /etc/systemd/system/catalogue.service

#load and start the service
systemctl daemon-reload
systemctl enable catalogue
systemctl start catalogue

cp ${script_location}/files/mongodb.repo /etc/yum.repos.d/mongodb.repo

#install mongodb-client
yum install mongodb-org shell -y

#Load Schema
mongo --host localhost </app/schema/catalogue.js



