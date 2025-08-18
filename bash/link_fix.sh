#!/bin/bash

# Ensure a search path is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <search_path>"
    exit 1
fi

SEARCH_PATH="$1"

# Find files containing "link: http" and process them
find "$SEARCH_PATH" -type f -exec grep -l "link: http" {} + | while read -r file; do
    sed -i '' -e '/^link: http/{
        s/^link: http/linkurl: http/
        i\
link: true
    }' "$file"
done

echo "Processing complete."
