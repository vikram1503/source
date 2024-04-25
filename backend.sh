#!/bin/bash
source ./common.sh

check_root

dnf module disable nodejs -y &>>$logfile
validate $? "disabling default nodejs"

dnf module enable nodejs:20 -y &>>$logfile
validate $? "enabling nodejs:20 version"


dnf install nodejs -y &>>$logfile
validate $? "installing nodejs"

id expense &>>$logfile
if [ $? -ne 0 ]
then 
useradd expense &>>$logfile
validate $? "creating expense user"
else
echo -e "expense user already created...$y skipping $n"
fi

mkdir -p /app &>>$logfile
validate $? "creating app directory"

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip &>>$logfile
validate $? "downloading backend code"

cd /app 
rm -rf /app/*   
unzip /tmp/backend.zip &>>$logfile
validate $? "extracted backend code"

npm install &>>$logfile
validate $? "installing nodejs dependencies"

cp /home/ec2-user/expense-shell/backend.service /etc/systemd/system/backend.service &>>$logfile
 validate $? "copied backend service"

 systemctl daemon-reload &>>$logfile
validate $? "daemon reload"

 systemctl start backend &>>$logfile
 validate $? "starting backend"
 
 systemctl enable backend &>>$logfile
 validate $? "enabling backend"

 dnf install mysql -y &>>$logfile
 validate $? "installing mysql client"

 mysql -h db.imvicky.online -uroot -p${mysql_root_password} < /app/schema/backend.sql &>>$logfile
validate $? "schema loading"

systemctl restart backend &>>$logfile
validate $? "restarting backend"


