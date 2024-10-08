#!/bin/bash
set -e
set -o pipefail

updatefile="$HOME/.updatecount"
updatecount=$(checkupdates | wc -l)

if [ $? -ne 0 ]; then
  updatecount="N/A"
fi

rm -f "$updatefile"
echo "$updatecount" > "$updatefile"
chmod a+rw "$updatefile"
