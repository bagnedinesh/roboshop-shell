script_location=$(pwd)
log=/tmp/roboshop.log
status_check(){
  if [ $? -eq 0 ]
  then echo -e "\e[1;32mSUCCESS\e[0m"
  else echo -e "\e[1;31mFAILURE\e[0m"

  echo "Refer log file for more information Log - $log"
  exit
  fi
}

print_head(){
  echo -e "\e[35m $1 \e[0m"
}

NODEJS(){
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
    useradd roboshop &>>${log}
    print_head "user added"
  fi
  status_check
  print_head "setup an app directory"
  mkdir -p /app &>>${log}
  status_check
  print_head "Download the application code"
  curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log}
  rm -rf /app/* &>>${log}
  cd /app
  unzip /tmp/${component}.zip &>>${log}
  status_check
  print_head "download the dependencies"
  cd /app
  npm install &>>${log}
  status_check

  print_head "Setup SystemD ${component} Service"
  cp ${script_location}/files/${component}.service /etc/systemd/system/${component}.service &>>${log}
  status_check
  print_head "load and start the service"
  systemctl daemon-reload &>>${log}
  systemctl enable ${component} &>>${log}
  systemctl start ${component} &>>${log}
  status_check

if [ ${load_schema} == "true" ]; then
    print_head "setup MongoDB repo"
    cp ${script_location}/files/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${log}
    status_check
    print_head "install mongodb-client"
    yum install mongodb-org-shell -y &>>${log}
    status_check
    print_head "Load Schema"
    mongo --host mongodb-dev.dineshbagne.tech </app/schema/${component}.js &>>${log}
    status_check
  fi
}