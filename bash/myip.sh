#!/bin/bash
set -e
set -o pipefail

#
# script to show public IP address
# from: http://lifehacker.com/5194123/display-your-public-ip-address-in-the-shell-prompt
# 20090402

curl -s myip.dk | grep '"Box"' | grep -E -o '[0-9.]+'
