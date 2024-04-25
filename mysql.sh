#!/bin/bash
userid=$(id -u)
timestamp=$(date +%F-%H-%M-%S)
scriptname=$( echo $0 | cut -d "." -f1 )
logfile=/tmp/$scriptname-$timestamp.log
r="\e[31m"
g="\e[32m"
y="\e[33m"
n="\e[0m"
echo "please enter db password:"
read -s mysql_root_password
validate(){
    if [ $1 -ne 0 ]
    then echo -e "$2...$r failure $n"
    exit 1
    else echo -e "$2...$g success $n"
    fi
}

if [ $userid -ne 0 ]
then 
echo "you are not super user get root access"
exit 1
else 
echo "you are super user"
fi

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