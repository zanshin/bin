#!/bin/sh
#
# ssh_host - JD Smith, Copyright (2005)
#
# Manage OSX terminal colors for various ssh hosts.  Works even with
# focus-follows-mouse, when the focused terminal is not the foremost.
# 
# Can be called as:
#
#   ssh_host hostname
#
# or, by making a link to this script:
#
#   cd ~/bin/
#   ln -s ssh_host hostname
#
# and then using the script link "hostname" without arguments.
#
# Configure host-based color below.  Unconfigured hosts will have a
# default color chosen based on the first three characters of their
# hostname.
#

host=${1:-${0##*/}}

########################################################################
# User editable section: Configure custom host colors here, adding new
# host cases as necessary
#
# Color Format: "R, G, B, A" for red, green, blue, and opacity (0-65535)
#
# Example line to add:
#   foobar.baz.com*) host_color="20000, 20000, 10000, 65535";;
#

# The default opacity value if not specified (0-65535)
default_opacity=61000

# The default color which will be used when not connected to any host.
default_color="0, 0, 0, $default_opacity"

case "$host" in
### Add matching host cases here:
    palantir*) host_color="5000, 20000, 5000, 63000";;
########################################################################

    *)  # Compute default color based on first three letters of hostname
	declare -a cols
	cols=($(echo -ne $host | tr 'A-Z' 'a-z' | tr -cd 'a-z' | od -t d1 | \
	    head -n1 | cut -c10-22));
	r=$(expr \( ${cols[0]:-122} - 97 \) \* 13107 / 5 );
	g=$(expr \( ${cols[1]:-122} - 97 \) \* 13107 / 5 );
	b=$(expr \( ${cols[2]:-122} - 97 \) \* 13107 / 5 );
	host_color="$r, $g, $b, $default_opacity";
	;;
esac

window_name="${host}_SSH_$$"

trap cleanup 1 2 3 6

function cleanup() {
    set_color "$default_color"
    echo -n -e "\e]0;\a"
}

function set_color() {
    echo -n -e "\e]0;${window_name}\a"
    osascript -e 'tell application "Terminal" to tell (first window whose name contains "'$window_name'") to set background color to {'"$1"'}'
}

set_color "$host_color"
ssh -X $host
cleanup