#!/bin/bash



source ./common.sh

check_root 

echo "please enter db password"
read -s mysql_root_password

dnf install mysql-server -y &>>$logfile 
validate $? "installing my sql server"

systemctl enable mysqld &>>$logfile
validate $? "enabling mysql server"

systemctl start mysqld &>>$logfile
validate $? "starting mql server"
 
# mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$logfile
# validate $? "setting up root password "
mysql -h db.imvicky.online -uroot -p${mysql_root_password} -e 'show databases;'  &>>$logfile
if [ $? -ne 0 ]
then 
   mysql_secure_installation --set-root-pass ${mysql_root_password} &>>$logfile
   validate $? "mysql root password setup"
   else 
   echo -e "mysql root password is already set...$y skipping $n"
   fi