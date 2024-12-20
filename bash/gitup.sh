#!/bin/bash

BASE_DIR="$1"

BLUE='\033[1;34m'
NC='\033[m'

if [[ -z "$BASE_DIR" ]]; then
  echo "Usage: $0 <directory>"
  exit 1
fi

if [[ ! -d "$BASE_DIR" ]]; then
  echo "Error: Directory '$BASE_DIR' does not exist."
  exit 1
fi

for dir in "$BASE_DIR"/*; do
  if [[ -d "$dir/.git" ]]; then
    echo
    echo -e "${BLUE}Updating repository: $dir${NC}"
    (cd "$dir" && git update)
  else
    echo "Skipping: $dir (not a Git repository)" 
  fi
done
