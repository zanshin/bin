#!/bin/bash

set -e
set -o pipefail

# um.sh
# Create X-Windows session for Universal Messaging client
#

echo "xauth extract /tmp/xauth.$$ `hostname`/unix:${DISPLAY##*:}"
xauth extract /tmp/xauth.$$ `hostname`/unix:${DISPLAY##*:}

echo "export XAUTHORITY=/tmp/xauth.$$"
export XAUTHORITY=/tmp/xauth.$$

echo "chmod a+r /tmp/xauth.$$"
chmod a+r /tmp/xauth.$$

echo "cd /opt/softwareag/UniversalMessaging/java/umserver/bin"
cd /opt/softwareag/UniversalMessaging/java/umserver/bin

echo "sudo -u webmeth ./nenterprisemgr"
sudo -u webmeth ./nenterprisemgr

