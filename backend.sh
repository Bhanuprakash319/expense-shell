#!/bin/bash
userid=$(id -u)
timestamp=$(date +%F-%H-%M-%S)
filename=$(echo $0 | cut -d "." -f1)
logfile=/tmp/$filename-$timestamp.log

r="\e[31m"
g="\e[32m"
n="\e[0m"

if [ $userid -eq 0 ]
then
    echo -e "$g You are super user $n"
else
    echo -e "$r You are not super user$n"
    exit 1
fi

validate(){
    if [ $1 -eq 0 ]
    then 
         echo -e "$2 is $g successfull$n"
    else
         echo -e "$2 is $r failure$n"
         exit 1
    fi
}

dnf module disable nodejs -y &>> $logfile
validate $? "disabling nodejs module"

dnf module enable nodejs:20 -y &>> logfile
validate $? "enabling nodejs version"

dnf install nodejs -y &>> $logfile
validate $? "installing nodejs"

id expense &>> $logfile
if [ $? -eq 0 ]
then 
     echo -e "$g User already exists $n"
else
     useradd expense
     validate $? "adding user expense"
fi

mkdir -p /app 
validate $? "creating app directory"

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip &>> $logfile
validate $? "Dowloading the code"

cd /app
rm -rf /app/*
unzip /tmp/backend.zip &>> $logfile
validate $? "unzipping the code"