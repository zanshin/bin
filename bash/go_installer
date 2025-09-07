set -e
set -o pipefail

# go_installer.sh
#
# go_installer.sh collects the series of commands necessary to update (install)
# Go on a Raspberry Pi.
#
export GOLANG="$(curl https://golang.org/dl/|grep linux-armv6l|grep -v beta|head -1|awk -F\> {'print $3'}|awk -F\< {'print $1'})"
wget https://golang.org/dl/$GOLANG
sudo tar -C /usr/local -xzf $GOLANG
rm $GOLANG
unset GOLANG
