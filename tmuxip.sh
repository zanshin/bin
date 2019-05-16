#!/bin/sh
PUBIP=`curl -s https://api.ipify.org | awk '{print $1}'`
if [[ `uname -a | grep -i darwin` ]]; then
  OTHERIPS=`netstat -i -n | egrep "([0-9]{1,3}\.){3}[0-9]{1,3}" | grep -v lo | awk '{print " : " $1":"$4}'`
else
  OTHERIPS=`for i in `netstat -i | egrep -v "^(Iface|lo|Ker)" | awk '{print $1}'` ; do echo -ne $i ; ip -4 addr show $i | grep inet | awk '{print " : " $2}' ; done`
fi
echo $PUBIP $OTHERIPS
