#!/bin/bash

DATE=$( date +%F )
LOG_DIR=/home/ec2-user
LOG_FILE=$LOG_DIR/$0-$DATE.log
USERID=$( id -u )
R="\e[31m"
G="\e[32m"
N="\e[0m"

if [ $USERID -ne 0 ]
then
echo not a root
exit 1
fi 

VALIDATE(){
    if [ $1 -ne 0 ];
    then
    echo installing $2 failed
    exit 1
    else
    echo installing $2 success
    fi
}

cp mongo.repos /etc/yum.repos.d/mongo.repo

VALIDATE $? " copied mongodb repo into yum.repos.d "

yum install mongodb-org -y &>>$LOG_FILE

VALIDATE $? "installing mongodb"  # corrected the validation message

systemctl enable mongod
VALIDATE $? "enabling"
systemctl start mongod
VALIDATE $? "enabling"
sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
VALIDATE $? "enabling"
systemctl restart mongod
VALIDATE $? "enabling"
