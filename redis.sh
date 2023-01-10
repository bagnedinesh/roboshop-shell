source common.sh

print_head "install rpm for Redis"
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y
status_check

print_head "Enable Redis 6.2 from package streams"
dnf module enable redis:remi6.2 -y
status_check

print_head "Install redis"
yum install redis -y
status_check

print_head "Update listen address from 127.0.0.1 to 0.0.0.0"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.conf /etc/redis/redis.conf &>>${log}
status_check

print_head "Start & Enable Redis Service"
systemctl enable redis
systemctl start redis
status_check