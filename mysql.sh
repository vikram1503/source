#!/bin/bash

source ./common.sh

check_root
echo "please enter db password:"
read -s mysql_root_password

dnf install mysql-server -y &>>$logfile 


systemctl enable mysqld &>>$logfile


systemctl start mysqld &>>$logfile

 

mysql -h db.imvicky.online -uroot -p${mysql_root_password} -e 'show databases;'  &>>$logfile
if [ $? -ne 0 ]
then 
   mysql_secure_installation --set-root-pass ${mysql_root_password} &>>$logfile
  
   else 
   echo -e "mysql root password is already set...$y skipping $n"
   fi