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