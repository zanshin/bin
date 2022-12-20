#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail


main() {
  echo "Git aliases "
  echo "synced git pull origin $(git mainbranch) --rebase"
  echo "update - git pull origin $(git rev-parse --abbrev-ref HEAD) --rebase"
  echo "squash - git rebase -v- i $(git mainbranch)"
  echo "[pub]lish - push origin HEAD --force-with-lease"
  echo ""
}

main "$@"
