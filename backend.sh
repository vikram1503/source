#!/bin/bash

source ./common.sh

check_root

dnf module disable nodejs -y &>>$logfile

dnf module enable nodejs:20 -y &>>$logfile

dnf install nodejs -y &>>$logfile


id expense &>>$logfile

if [ $? -ne 0 ]
then 
useradd expense &>>$logfile

else
echo -e "expense user already created...$y skipping $n"
fi

mkdir -p /app &>>$logfile


curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip &>>$logfile


cd /app 
rm -rf /app/*   
unzip /tmp/backend.zip &>>$logfile


npm install &>>$logfile


cp /home/ec2-user/expense-shell/backend.service /etc/systemd/system/backend.service &>>$logfile


 systemctl daemon-reload &>>$logfile


 systemctl start backend &>>$logfile

 
 systemctl enable backend &>>$logfile


 dnf install mysql -y &>>$logfile
 

 mysql -h db.imvicky.online -uroot -p${mysql_root_password} < /app/schema/backend.sql &>>$logfile


systemctl restart backend &>>$logfile
 


