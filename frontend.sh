#!/bin/bash
userid=$(id -u)
timestamp=$(date +%F-%H-%M-%S)
scriptname=$( echo $0 | cut -d "." -f1 )
logfile=/tmp/$scriptname-$timestamp.log
r="\e[31m"
g="\e[32m"
y="\e[33m"
n="\e[0m"

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








