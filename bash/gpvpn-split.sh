#!/bin/bash
set -e
set -o pipefail

# Dependencies
# brew install iproute2mac - gets ip command for macOS
if ! [[ -x $(command -v ip) ]] ; then
  echo "ip command not found"
  echo "Run brew install iproute2mac to install it"
  echo "Then run $0 again"
  exit
fi

# Colors
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

# This script works on macOS. It futzes with the routing table
# to only route 10.* and 129.130.* traffic over the Global Protect
# VPN, if that VPN is active.

# Detemine what gateway traffic is flowing through
GATEWAY=$(netstat -nr | grep -v "::" | grep default | grep -v utun | awk '{print $2}')
echo -e "Gateway:                ${BLUE}$GATEWAY${NC}"

# Determine which network interface the host is using
LOCAL_IFACE=$(ip route show | grep default | grep -v utun | awk '{print $5}')
echo -e "Local interface in use: ${BLUE}$LOCAL_IFACE${NC}"

# GP VPN IP range and prefix - macOS strips the `.0` in the netmask
GPVPN_RANGE="10.130.48.0/20"
GPVPN_PREFIX="^10.130.48"
echo -e "Global Protect range:   ${BLUE}$GPVPN_RANGE${NC}"
echo -e "Global Protect prefix:  ${BLUE}$GPVPN_PREFIX${NC}"

# Protect local IP from being routed
if [[ "$(netstat -nr | grep -E "192\.168\.4\.1")" ]] ; then
  VERB="replace"
else
  VERB="add"
fi

echo
echo "Setting a route for the local network"
echo -e "     ${RED}ip route $VERB 192.168.0.0/2 dev $LOCAL_IFACE ${NC}"
sudo ip route "$VERB" 192.168.0.0/16 dev "$LOCAL_IFACE"

if [[ "$(netstat -nr | grep -E $GPVPN_PREFIX)" ]] ; then
  VERB="change"
else
  VERB="add"
fi

echo
echo "Setting a route for the GP VPN"
echo -e "     ${RED}route $VERB $GPVPN_RANGE $GATEWAY ${NC}"
sudo route "$VERB" "$GPVPN_RANGE" "$GATEWAY"

# Start the VPN...
# sudo openconnect  --user=mhn --protocol=gp --csd-user=mhn --csd-wrapper="$HOME/sec/openconnect/hipreport.sh" --script "$HOME/src/openconnect/vpnc-script" gpvpn.ksu.edu
sudo openconnect --servercert pin-sha256:WmsRWWmtMqC2/sVCT/kVjZo1JnS2swkXj2bwZknc7Kk=  --user=mhn --protocol=gp --script "$HOME/src/openconnect/vpnc-script" gpvpn.ksu.edu

exit 0
