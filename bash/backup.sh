#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

# Enable debug mode, by running script as TRACE=1 ./script.sh
if [[ "${TRACE-0}" == "1" ]]; then
  set -o trace
fi


main() {

  filename="/Volumes/WasabiRsync/backup/backup_$(date +%F).log"
  touch "$filename"
  echo "backing up code directory"
  rsync -azh --progress --delete --log-file="$filename" --filter="- *.DS_Store" ~/code /Volumes/WasabiRsync/backup/
  echo "backing up Desktop directory"
  rsync -azh --progress --delete --log-file="$filename" --filter="- *.DS_Store" ~/Desktop /Volumes/WasabiRsync/backup/
  echo "backing up Documents directory"
  rsync -azh --progress --delete --log-file="$filename" --filter="- *.DS_Store" ~/Documents /Volumes/WasabiRsync/backup/
  echo "backing up Downloads directory"
  rsync -azh --progress --delete --log-file="$filename" --filter="- *.DS_Store" ~/Downloads /Volumes/WasabiRsync/backup/
  echo "backing up src directory"
  rsync -azh --progress --delete --log-file="$filename" --filter="- *.DS_Store" ~/src /Volumes/WasabiRsync/backup/
}

main "$@"
