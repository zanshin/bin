#!/bin/bash

GW=$(netstat -nr | egrep "^(0\.0\.0\.0|default)" | grep -v tun | grep -v en1 | awk '{print $2}')
VPNET="10.130.139.0/25"
VPRE="10.130.139" # VPN prefix (macOS strips the .0 in the netmask)

/opt/cisco/anyconnect/bin/vpn -s connect vpn.net.k-state.edu
# sudo openconnect -b -v vpn.net.k-state.edu --user=mhn
# --authgroup=ESTVPN_new-D

# route redo seems to fail if it happens too soon...
sleep 3

if [[ `uname -a | grep -i linux` ]]; then
  if [[ `netstat -nr | egrep $VPRE` ]]; then VERB="replace"; else VERB="add"; fi
  echo " ip route $VERB $VPNET via $GW "
  sudo ip route $VERB $VPNET via $GW
else
  if [[ `netstat -nr | egrep $VPRE` ]]; then VERB="change"; else VERB="add"; fi
  echo " route $VERB $VPNET $GW "
  sudo route $VERB $VPNET $GW
fi
