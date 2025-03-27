userid=$(id -u)
if [ $userid -eq 0 ]
then
    echo "You are super user"
else
    echo "You are not super user"
    exit 1
fi