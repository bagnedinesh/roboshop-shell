#MongoDB

script_location=$(pwd)

cp ${script_location}/files/mongodb.repo /etc/yum.repos.d/mongodb.repo

#Install MongoDB
yum install mongodb-org -y

#Update listen address from 127.0.0.1 to 0.0.0.0 in /etc/mongod.conf
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf

#Start & Enable MongoDB Service
systemctl enable mongod
systemctl restart mongod

