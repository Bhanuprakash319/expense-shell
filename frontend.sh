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

dnf install nginx -y &>> $logfile
validate $? "installing nginx"

systemctl enable nginx  &>> $logfile
validate $? "enabling nginx"

systemctl start nginx &>> $logfile
validate $? "starting nginx"

rm -rf /usr/share/nginx/html/* &>> $logfile
validate $? "removing default content"

curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip &>> $logfile
validate $? "downloading the code"

cd /usr/share/nginx/html

unzip /tmp/frontend.zip &>> $logfile
validate $? "unzipping the file"

cp /home/ec2-user/expense-shell/expense.conf /etc/nginx/default.d/expense.conf &>> $logfile
validate $? "copying the file"

systemctl restart nginx &>> $logfile
validate $? "restarting nginx"