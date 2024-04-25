#!/bin/bash
source ./common.sh

check_root

dnf install nginx -y &>>$logfile
validate $? "installing nginx"

systemctl enable nginx &>>$logfile
validate $? "enabling nginx"

systemctl start nginx &>>$logfile
validate $? "starting nginx"

rm -rf /usr/share/nginx/html/*
validate $? "removing existing content"

curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip
validate $? "downloading front code"

cd /usr/share/nginx/html
unzip /tmp/frontend.zip &>>$logfile
validate $? "extracting code"

cp /home/ec2-user/expense-shell/expense.conf /etc/nginx/default.d/expense.conf
validate $? "copied expense conf"

systemctl restart nginx &>>$logfile
validate $? "restarting nginx"








