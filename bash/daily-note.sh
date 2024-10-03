#!/bin/bash

set -e
set -o pipefail

# note.sh
# Creates a new daily note file, if not found, and adds timestamp
# ahead of insertion point. If note is closed without saving, the
# timestamp is not saved.
#

# noteFilename="$HOME/Nextcloud/documents/notes/note-$(date +%Y-%m-%d).md"
noteFilename="$HOME/Documents/notes/daily/note-$(date +%Y-%m-%d).md"

if [ ! -f "$noteFilename" ]; then
  echo "# Notes for $(date +%Y-%m-%d)" > "$noteFilename"
fi

nvim -c "norm Go" \
  -c "norm Go## $(date +"%I:%M %p")" \
  -c "norm G2o" \
  -c "norm zz" \
  -c "startinsert" "$noteFilename"


