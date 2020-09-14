#! /bin/bash
set -e
set -o pipefail

# appender.sh
#
# appender.sh appends a variety of things to the end of a file.
# It is specifically for appending items to the `inbox.md` file
# in my ouroborus wiki.
#
# Flag - Purpose
# -u - append a URL and its description
# -q - append a quote and its source
# -t - append a tweet
# -r - append random text
# -T - append a to do

# 0 args, return usage
# 1 arg, has to be `-t`, `-T` or `-r`
# 2 args, has to be `-u` or `-q`

if [[ $# -ne 2 && $# -ne 3 ]]; then
  echo "Usage: $0 -u <URL> <description>"
  echo "     : $0 -q <quote> <source>"
  echo "     : $0 -t <tweet URL>"
  echo "     : $0 -r <random text>"
  echo "     : $0 -T <to do text>"
  exit 2
fi

# Location of inbox.md
inbox_location="$HOME/code/ouroborus/docs/inbox.md"
inboxdayfile="$HOME/code/ouroborus/docs/.inboxday"

# Date
year=$(date '+%Y')
month=$(date '+%m')
day=$(date '+%d')

# Add date to inbox, if necessary
inboxday=$(<"$inboxdayfile")

if [[ "$inboxday" -ne "$day" ]]; then
  printf "\n$month/$day/$year\n" >> "$inbox_location"
  echo "$day" > "$inboxdayfile"
fi

# Determine what flag was passed in
case "$1" in
  -u) # <url> <description>
    echo "* [$3]($2)" >> "$inbox_location"
    ;;
  -q) # <quote> <description>
    echo "* $2 ~ $3" >> "$inbox_location"
    ;;
  -t) # <tweet>
    echo "* $2" >> "$inbox_location"
    ;;
  -r) # <random text>
    echo "* $2"  >> "$inbox_location"
    ;;
  -T) # <todo>
    echo "* [ ] - $2"  >> "$inbox_location"
    ;;
esac


echo "done"
exit 0

