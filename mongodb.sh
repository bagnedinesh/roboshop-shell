#MongoDB

script_location=$(pwd)
log=/tmp/roboshop.log

echo -e "\e[35m Set up mongodb repo \e[0m"
cp ${script_location}/files/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${log}

echo -e "\e[35m Install MongoDB \e[0m"
yum install mongodb-org -y &>>${log}

echo -e "\e[35m Update listen address from 127.0.0.1 to 0.0.0.0 in /etc/mongod.conf \e[0m"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>${log}

echo -e "\e[35m Start & Enable MongoDB Service \e[0m"
systemctl enable mongod &>>${log}
systemctl restart mongod &>>${log}

