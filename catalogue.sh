#Catalogue is a microservice that is responsible for serving the list of items
# that displays in roboshop application.
log=/tmp/roboshop.log
script_location=$(pwd)
#Setup NodeJS repos
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log}

#Install NodeJS
yum install nodejs -y &>>${log}

#Add application User
useradd roboshop &>>${log}

#setup an app directory
mkdir -p /app &>>${log}

#Download the application code
curl -L -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${log}
rm -rf /app/* &>>${log}
cd /app
unzip /tmp/catalogue.zip &>>${log}

# download the dependencies
cd /app
npm install &>>${log}

#Setup SystemD Catalogue Service
cp ${script_location}/files/catalogue.service /etc/systemd/system/catalogue.service &>>${log}

#load and start the service
systemctl daemon-reload &>>${log}
systemctl enable catalogue &>>${log}
systemctl start catalogue &>>${log}

#setup MongoDB repo
cp ${script_location}/files/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${log}

#install mongodb-client
yum install mongodb-org-shell -y &>>${log}

#Load Schema
mongo --host mongodb-dev.dineshbagne.tech </app/schema/catalogue.js &>>${log}



