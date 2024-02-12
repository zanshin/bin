#!/bin/bash
set -e
set -o pipefail

# UTUNIP=$(ifconfig | grep "inet 10.130" | grep -v broadcast | awk '{print $2}')
UTUNIP=$(ifconfig | grep "inet 100." | awk '{print $2}')
echo " ts: $UTUNIP"
