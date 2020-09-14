#!/bin/bash
set -e
set -o pipefail

updatefile="$HOME/.updatecount"
updatecount=$(checkupdates | wc -l)

rm -f "$updatefile"
echo "$updatecount" > "$updatefile"
chmod a+rw "$updatefile"
