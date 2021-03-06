#!/bin/bash


ioreg -l | grep "product-name" | awk -F\" '{print $4" "}'
sw_vers | awk -F':\t' '{print $2}' | paste -d ' ' - - -;
sysctl -n hw.memsize | awk '{print $0/1073741824" GB "}';
df -hl | grep 'Data' | awk '{print $4"/"$2" free ("$5" used) "}'
ioreg -l | grep "IOPlatformSerialNumber" | awk -F\" '{print " "$4}'
