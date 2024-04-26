#!/bin/bash

source_directory=/tmp/app-logs

r="\e[31m"
g="\e[32m"
y="\e[33m"
n="\e[0m"


if [ -d $source_directory ]
then
echo -e "$g source directory exists$n"
else
echo -e "$r please make sure $source_directory exists $n"
exit 1
fi

files=$(find $source_directory -name "*.log" -mtime +14)

while IFS= read -r line 
do
echo "deleting file:$line"
rm -rf $line 

done <<< $files