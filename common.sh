script_location=$(pwd)
log=/tmp/roboshop.log
status_check(){
  if [ $? -eq 0 ]
  then echo -e "\e[1;32mSUCCESS\e[0m"
  else echo -e "\e[1;31mFAILURE\e[0m"

  echo "Refer log file for more information log - $log"
  exit
  fi
}

print_head(){
  echo -e "\e[35m $1 \e[0m"
}
APP_PREREQ() {

  print_head "Add Application User"
  id roboshop &>>${log}
  if [ $? -ne 0 ]; then
    useradd roboshop &>>${log}
  fi
  status_check

  mkdir -p /app &>>${log}

  print_head "Downloading App content"
  curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log}
  status_check

  print_head "Cleanup Old Content"
  rm -rf /app/* &>>${log}
  status_check

  print_head "Extracting App Content"
  cd /app
  unzip /tmp/${component}.zip &>>${log}
  status_check

}
SYSTEMD_SETUP() {
  print_head "Configuring ${component} Service File"
  cp ${script_location}/files/${component}.service /etc/systemd/system/${component}.service &>>${log}
  status_check

  print_head "Reload SystemD"
  systemctl daemon-reload &>>${log}
  status_check

  print_head "Enable ${component} Service "
  systemctl enable ${component} &>>${log}
  status_check

  print_head "Start ${component} service "
  systemctl start ${component} &>>${log}
  status_check
}
LOAD_SCHEMA() {
  if [ ${schema_load} == "true" ]; then

    if [ ${schema_type} == "mongo"  ]; then
      print_head "Configuring Mongo Repo "
      cp ${script_location}/files/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${log}
      status_check

      print_head "Install Mongo Client"
      yum install mongodb-org-shell -y &>>${log}
      status_check

      print_head "Load Schema"
      mongo --host mongodb-dev.devopsb70.online </app/schema/${component}.js &>>${log}
      status_check
    fi

    if [ ${schema_type} == "mysql"  ]; then

      print_head "Install MySQL Client"
      yum install mysql -y &>>${log}
      status_check

      print_head "Load Schema"
      mysql -h mysql-dev.devopsb70.online -uroot -p${root_mysql_password} < /app/schema/shipping.sql  &>>${log}
      status_check
    fi

  fi
}
NODEJS() {
  print_head "Configuring NodeJS Repos"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log}
  status_check

  print_head "Install NodeJS"
  yum install nodejs -y &>>${log}
  status_check

  APP_PREREQ

  print_head "Installing NodeJS Dependencies"
  cd /app &>>${log}
  npm install &>>${log}
  status_check

  SYSTEMD_SETUP

  LOAD_SCHEMA
}

MAVEN() {

  print_head "Install Maven"
  yum install maven -y &>>${log}
  status_check

  APP_PREREQ

  print_head "Build a package"
  mvn clean package  &>>${log}
  status_check

  print_head "Copy App file to App Location"
  mv target/${component}-1.0.jar ${component}.jar
  status_check

  SYSTEMD_SETUP

  LOAD_SCHEMA

}

PYTHON() {

  print_head "Install Python"
  yum install python36 gcc python3-devel -y &>>${log}
  status_check

  APP_PREREQ

  print_head "Download Dependencies"
  cd /app
  pip3.6 install -r requirements.txt  &>>${log}
  status_check

  print_head "Update Passwords in Service File"
  sed -i -e "s/roboshop_rabbitmq_password/${roboshop_rabbitmq_password}/" ${script_location}/files/${component}.service  &>>${log}
  status_check

  SYSTEMD_SETUP

}