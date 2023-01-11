source common.sh

if [ -z "${roboshop_rabbitmq_password}" ]; then
  echo "Variable roboshop_rabbitmq_password is missing"
  exit 1
fi

print_head "Configuring Erlang YUM Repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | sudo bash &>>${log}
status_check

print_head "Configuring RabbitMQ YUM Repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>>${log}
status_check

print_head "Install Erlang & RabbitMQ"
yum install erlang rabbitmq-server -y  &>>${log}
status_check

print_head "Enable RabbitMQ Server"
systemctl enable rabbitmq-server  &>>${log}
status_check

print_head "Start RabbitMQ Server"
systemctl start rabbitmq-server  &>>${log}
status_check

print_head "Add Application User"
rabbitmqctl list_users | grep roboshop &>>${log}
if [ $? -ne 0 ]; then
  rabbitmqctl add_user roboshop ${roboshop_rabbitmq_password}  &>>${log}
fi
status_check

print_head "Add Tags to Application User"
rabbitmqctl set_user_tags roboshop administrator  &>>${log}
status_check

print_head "Add permission to Application User"
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"  &>>${log}
status_check
