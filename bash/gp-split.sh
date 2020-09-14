#!/bin/bash
set -e
set -o pipefail

GW=$(netstat -nr | grep -eq "^(0\.0\.0\.0|default)" | grep -v tun | awk '{print $2}')
VPNET="10.130.48.0/20"
VPRE="^10.130.48" # VPN prefix (OSX strips the .0 in the netmask)


if ! [[ $(uname -a | grep -iq linux) ]]; then
    echo Not linux -- assuming OS X
    echo geting default gw
    IFS=" " read -r w1 w2 w3 w4 < <(netstat -nr -f inet  | grep default)
    # netstat -nr -f inet  | grep default
    # default            10.130.126.1       UGSc           en0
    DROUTE=$w2
    echo saving $w2 as default route
else
    echo geting default gw
    IFS=" " read -r w1 w2 w3 w4 w5 junk< <(ip route | grep default)
    #default via 192.168.1.1 dev enp0s31f6 proto dhcp metric 100
    DROUTE=$w3
    echo saving  "$w3" as default route
fi

if [[ $(uname -a | grep -iq linux) ]]; then
    if [[ $(netstat -nr | grep -eq $VPRE) ]]; then VERB="replace"; else VERB="add"; fi
    echo " ip route $VERB $VPNET via $GW "
    sudo ip route $VERB $VPNET via "$GW"
else
    if [[ $(netstat -nr | grep -eq $VPRE) ]]; then VERB="change"; else VERB="add"; fi
    echo " route $VERB $VPNET $GW"
    sudo route $VERB $VPNET "$GW"
fi

sudo openconnect  -b --user=brad --protocol=gp gpvpn.ksu.edu

sleep 3



PRIVNET="10.0.0.0/8"
PRIVPRE="^10"
PUBNET="129.130.0.0/16"
PUBPRE="^129.130" # VPN prefix (OSX strips the .0 in the netmask)

if [[ $(uname -a | grep -iq linux) ]]; then
    IFS=" " read -r w1 w2 w3 < <(ip route show | grep tun | grep default)
    # w1, 2, 3 => default dev tun0 -- in theory  maybe vary?
    sudo ip route delete "$w1" "$w2" "w3"
    sudo ip route add $PRIVNET dev "$w3"
    sudo ip route add $PUBNET dev "$w3"
    # sudo ip route add 10.130.0.0/8 dev tun0
else
    # if [[ `netstat -nr | egrep $VPRE` ]]; then VERB="change"; else VERB="add"; fi
    # echo " route $VERB $VPNET $GW"
    # sudo route $VERB $VPNET $GW
    IFS=" " read -r w1 w2 w3 w4 < <(netstat -nr -f inet | grep tun | grep default)
    # default            10.130.49.72       UGSc         utun2
    sudo route delete "$w1" "$w2"
    echo re-establishing default route "$DROUTE"
    sudo route add default "$DROUTE"
    sudo route add $PUBNET "$w2"
    sudo route add $PRIVNET "$w2"
    # sleep 30
    # sudo route delete $PUBNET $w2
    # sudo route delete $PRIVNET $w2
    # echo os x not yet implemented
fi
