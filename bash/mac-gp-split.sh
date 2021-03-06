#!/bin/bash
set -e
# set -o pipefail

# ##
# This script adds a new route to the routing table in macOS to only
# send 10. and 129.130. traffic over the established VPN connection.
# All other traffic by-passes the extablished VPN.
#
# Assumptions:
# 1. The macOS version is Catalina. (This will *probably* work on other recent
#    macOS releases.)
# 2. The VPN being used is GlobalProtect.
# 3. Your local network is a 192. network. If you are using a 10. network
#    locally, this script will likely not work without tweaking.
# ##
echo "starting"
# GW=$(netstat -nr | grep -e "default" | grep -v tun | grep -v 192 | awk '{print $2}')
GW=$(netstat -nr | grep -e "default" | grep -v tun | awk '{print $2}')
echo "Gateway: $GW"

VPNET="10.130.48.0/20"
echo "Netmask: $VPNET"

VPRE="^10.130.48"
echo "Mac Netmask: $VPRE"

# if ! [[ $(uname -a | grep -iq linux) ]]; then
DROUTE=$(netstat -nr -f inet | grep default | awk '{print $2}')
echo "Found default route: $DROUTE"

if [[ $(netstat -nr | grep -E $VPRE) ]]; then VERB="change"; else VERB="add"; fi
echo "Running the following route command: route $VERB $VPNET $GW"
sudo route $VERB $VPNET "$GW"

sudo openconnect  -b --user=mhn --protocol=gp gpvpn.ksu.edu

sleep 3

echo "VPN established. I hope..."


# PRIVNET="10.0.0.0/8"
# PRIVPRE="^10"
# PUBNET="129.130.0.0/16"
# PUBPRE="^129.130" # VPN prefix (OSX strips the .0 in the netmask)
#
# if [[ $(uname -a | grep -iq linux) ]]; then
#     IFS=" " read -r w1 w2 w3 < <(ip route show | grep tun | grep default)
#     # w1, 2, 3 => default dev tun0 -- in theory  maybe vary?
#     sudo ip route delete "$w1" "$w2" "w3"
#     sudo ip route add $PRIVNET dev "$w3"
#     sudo ip route add $PUBNET dev "$w3"
#     # sudo ip route add 10.130.0.0/8 dev tun0
# else
#     # if [[ `netstat -nr | egrep $VPRE` ]]; then VERB="change"; else VERB="add"; fi
#     # echo " route $VERB $VPNET $GW"
#     # sudo route $VERB $VPNET $GW
#     IFS=" " read -r w1 w2 w3 w4 < <(netstat -nr -f inet | grep tun | grep default)
#     # default            10.130.49.72       UGSc         utun2
#     sudo route delete "$w1" "$w2"
#     echo re-establishing default route "$DROUTE"
#     sudo route add default "$DROUTE"
#     sudo route add $PUBNET "$w2"
#     sudo route add $PRIVNET "$w2"
#     # sleep 30
#     # sudo route delete $PUBNET $w2
#     # sudo route delete $PRIVNET $w2
#     # echo os x not yet implemented
# fi
