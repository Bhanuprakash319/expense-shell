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
    if [ $1 eq 0 ]
    then 
         echo -e "$g $2 is successfull$n"
    else
         echo -e "$r $2 is failure$n"
         exit 1
    fi
}

dnf install mysql-server -y &>> $logfile
validate $? "installing mysql-server"

