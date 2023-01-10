source common.sh

print_head "install rpm for Redis"
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>${log}
status_check

print_head "Enable Redis 6.2 from package streams"
dnf module enable redis:remi6.2 -y &>>${log}
status_check

print_head "Install redis"
yum install redis -y &>>${log}
status_check

print_head "Update listen address from 127.0.0.1 to 0.0.0.0"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.conf /etc/redis/redis.conf &>>${log}
status_check

print_head "Start & Enable Redis Service"
systemctl enable redis &>>${log}
systemctl start redis &>>${log}
status_check