#!/bin/bash
set -e
set -o pipefail

echo
find . -type d -name ".git" -execdir bash -c '
    if [ ! $(git status | grep -o nothing) ]
        then
        x=$(basename "$PWD")
        y=$(dirname "$PWD")
        echo -e "\033[1;32m${x}\033[0m (${y})" >&2
        git status -s >&2
        git branch >&2
        echo >&2
    fi
' \; > /dev/null
