#!/bin/bash

DATE=$( date +%F )
LOG_DIR=/home/ec2-user/roboshop-logs
LOG_FILE=$LOG_DIR/$0-$DATE.log
USERID=$( id -u )
R="\e[31m"
G="\e[32m"
N="\e[0m"

if [ $USERID -ne 0 ]; then
    echo "You must run this script with root privileges."
    exit 1
fi 

VALIDATE(){
    if [ $1 -ne 0 ]; then
        echo "Installing $2 failed."
        exit 1
    else
        echo "Installing $2 success."
    fi
}

touch /etc/yum.repos.d/mongo12.repos

cp mongo1.repos /etc/yum.repos.d/mongo12.repos &>> $LOG_FILE

VALIDATE $? "copying mongo into yum.repos.d"

yum install mongodb-org -y &>> $LOG_FILE

VALIDATE $? "installing MongoDB"  # corrected the validation message

systemctl enable mongod
VALIDATE $? "enabling MongoDB service"

systemctl start mongod
VALIDATE $? "starting MongoDB service"

sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
systemctl restart mongod
