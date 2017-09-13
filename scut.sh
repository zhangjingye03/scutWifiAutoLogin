#!/bin/sh
# Copyright (C) 2017 ZJY

# Your student ID here
username="201712345678"
# Your login password here
password="Hello World"

# Auto get the interface which has the default route
int=$(ip -4 route  | grep default | cut -d " " -f 5)

# if the wlan is disconnected...
if [ $int"x" = "x" ]; then
  echo WLAN is not connected! Please check.
  exit
fi

# Auto get this device's IP addr
ip=$(ifconfig $int | grep "inet addr:" | sed 's/          inet addr://g' | cut -d " " -f 1)

if [ $1"x" = "upx" ]; then
  # online
  ret=$(curl -k -L -v --silent "https://s.scut.edu.cn:801/eportal/?c=ACSetting&a=Login&wlanuserip=$ip" --data "DDDDD=$username&upass=$password" 2>&1 | grep Location)
  curl -k -L  --silent "https://s.scut.edu.cn/errcode" | grep Rpost | grep -v if | sed 's/\///g'
  echo $ret | grep 3.htm
  if [ $? = 1 ]; then
    # unsuccessful; print the err msg
    echo Sorry, I cannot login! Please check the verbose above.
  else
    echo Logged in. Now you can surf the Internet!
  fi
elif [ $1"x" = "downx" ]; then
  ret=$(curl -k -L -v --silent "https://s.scut.edu.cn:801/eportal/?c=ACSetting&a=Logout&wlanuserip=$ip" --data "" 2>&1 | grep Location)
  # echo $ret
  echo Logged off. Good night~
else
  echo Unknown command.
  echo "Usage: $0 <up|down>""
fi
