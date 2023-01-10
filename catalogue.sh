#Catalogue is a microservice that is responsible for serving the list of items
# that displays in roboshop application.
source common.sh
echo -e "\e[35m Setup NodeJS repos \e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log}
status_check
echo -e "\e[35m Install NodeJS \e[0m"
yum install nodejs -y &>>${log}
status_check
echo -e "\e[35m Add application User \e[0m"
useradd roboshop &>>${log}
status_check
echo -e "\e[35m setup an app directory \e[0m"
mkdir -p /app &>>${log}
status_check
echo -e "\e[35m Download the application code \e[0m"
curl -L -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${log}
rm -rf /app/* &>>${log}
cd /app
unzip /tmp/catalogue.zip &>>${log}
status_check
echo -e "\e[35m download the dependencies \e[0m"
cd /app
npm install &>>${log}
status_check

echo -e "\e[35m Setup SystemD Catalogue Service \e[0m"
cp ${script_location}/files/catalogue.service /etc/systemd/system/catalogue.service &>>${log}
status_check
echo -e "\e[35m load and start the service \e[0m"
systemctl daemon-reload &>>${log}
systemctl enable catalogue &>>${log}
systemctl start catalogue &>>${log}
status_check

echo -e "\e[35m setup MongoDB repo \e[0m"
cp ${script_location}/files/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${log}
status_check
echo -e "\e[35m install mongodb-client \e[0m"
yum install mongodb-org-shell -y &>>${log}
status_check
echo -e "\e[35m Load Schema \e[0m"
mongo --host mongodb-dev.dineshbagne.tech </app/schema/catalogue.js &>>${log}
status_check



