#MongoDB

source common.sh

print_head "Set up mongodb repo"
cp ${script_location}/files/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${log}
status_check

print_head "Install MongoDB"
yum install mongodb-org -y &>>${log}
status_check
print_head "Update listen address from 127.0.0.1 to 0.0.0.0 in /etc/mongod.conf"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>${log}
status_check
print_head "Start & Enable MongoDB Service"
systemctl enable mongod &>>${log}
systemctl restart mongod &>>${log}
status_check

