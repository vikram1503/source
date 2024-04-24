#!/bin/bash
userid=$(id -u)
timestamp=$(date +%F-%H-%M-%S)
scriptname=$( $0 | cut -d "." -f1 )
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
 
 check_root(){
if [ $userid -ne 0 ]
then 
echo "you are not super user get root access"
exit 1
else 
echo "you are super user"
fi
 }