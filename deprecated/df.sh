#!/usr/bin/env bash
# vim: ft=sh

if [ ! -z "$*" ]; then
	echo "this is ~/bin/df, use /bin/df"
	exit 1
fi

protect=$(mount | grep -v "read-only" | grep "protect" | cut -f 3 -w)
nosuid=$(mount | grep -v "read-only" | grep "nosuid" | cut -f 3 -w)

/bin/df -PH "$protect" "$nosuid" | cut -f 2- -w
