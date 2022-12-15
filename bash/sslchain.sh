#!/usr/bin/env bash

# from https://sharats.me/posts/shell-script-best-practices/

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
  echo 'Usage: ./slchain.sh hostname

sslchain.sh parses the entire SSL chain for the given domain, and displays the dates each part is valid.

  '
  exit
fi

if [[ $# -ne 2 ]]; then
  echo "Usage: $0 <HOSTNAME> <PORT>"
  exit 2
fi

# If appropriate, change to the script’s directory close to the start of the script.
cd "$(dirname "$0")"

main() {
  echo "do awesome stuff"

  FULLCHAIN=$(openssl s_client -connect "$1":"$2" -showcerts 2>/dev/null </dev/null | sed -ne '/--BEGIN/,/--END/p')
  echo "$FULLCHAIN"
  PARTS=$(split -p "--BEGIN ")
}

main "$@"
