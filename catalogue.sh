#Catalogue is a microservice that is responsible for serving the list of items
# that displays in roboshop application.
source common.sh
print_head "Setup NodeJS repos"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log}
status_check
print_head "Install NodeJS"
yum install nodejs -y &>>${log}
status_check
print_head "Add application User"
id roboshop &>>${log}
print_head "id roboshop"
if [ $? -ne 0 ]
then
  print_head "id - $?"
  useradd roboshop &>>${log}
  print_head "user added"
fi
print_head "Syntax error"
status_check
print_head "setup an app directory"
mkdir -p /app &>>${log}
status_check
print_head "Download the application code"
curl -L -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${log}
rm -rf /app/* &>>${log}
cd /app
unzip /tmp/catalogue.zip &>>${log}
status_check
print_head "download the dependencies"
cd /app
npm install &>>${log}
status_check

print_head "Setup SystemD Catalogue Service"
cp ${script_location}/files/catalogue.service /etc/systemd/system/catalogue.service &>>${log}
status_check
print_head "load and start the service"
systemctl daemon-reload &>>${log}
systemctl enable catalogue &>>${log}
systemctl start catalogue &>>${log}
status_check

print_head "setup MongoDB repo"
cp ${script_location}/files/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${log}
status_check
print_head "install mongodb-client"
yum install mongodb-org-shell -y &>>${log}
status_check
print_head "Load Schema"
mongo --host mongodb-dev.dineshbagne.tech </app/schema/catalogue.js &>>${log}
status_check



