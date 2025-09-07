#!/usr/bin/env bash

# hpost.sh - Creates a new blog posting for the Hugo based site at $BLOG
# Expected to get a string for title. Script will replace spaces with dashes
# and append the `.md` file type. Finally it will open the new file in Neovim

# So that when a command fails, bash exits instead of continuing with the rest of the script.
set -o errexit

# This will make the script fail, when accessing an unset variable. Saves from horrible unintended consequences, with typos in variable names.
# When you want to access a variable that may or may not have been set, use "${VARNAME-}" instead of "$VARNAME", and you’re good.
set -o nounset

# This will ensure that a pipeline command is treated as failed, even if one command in the pipeline fails.
set -o pipefail

# People can now enable debug mode, by running your script as TRACE=1 ./script.sh instead of ./script.sh.
if [[ "${TRACE-0}" == "1" ]]; then
  set -o trace
fi

# Check if the first arg is -h or --help or help or just h or even -help, and in all these cases, print help text and exit.
if [[ "${1-}" =~ ^-*h(elp)?$ ]]; then
  echo 'Usage: ./hpost.sh "Title of New Posting" '
  exit
fi

DIR="${HOME}/code/hugo/blog"
cd "$(dirname "$DIR")"

main() {
  echo "Creating new posting..."
  $(hugo new posts/$(echo "$*" | sed 's/ /-/g').md)
  $(nvim)
}

main "$@"
