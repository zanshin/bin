#!/bin/bash
set -e

if [ "z$DEBUG" != "z" ]; then
    set -x
fi

_NOTES_PATH=${NOTES_PATH:-~/Documents/notes}
export FZF_DEFAULT_OPTS="-m --ansi --preview-window 'right:70%' --preview 'bat --color=always --style=header,grid --line-range :300 ${_NOTES_PATH}/{}'"

[ -d ${_NOTES_PATH} ] || mkdir ${_NOTES_PATH}

if [ ! -z "${1:-""}" ]; then
  case "$1" in
    "last"|"-")
      $EDITOR $(find ${_NOTES_PATH} -iname '*.md' | sort | tail -n1)
    ;;
    "search")
      shift
      files=$(rg --files-with-matches "$@" ${_NOTES_PATH})
      if [ ! -z "$files" ]; then
        if [ $(wc -l <<< "$files") = "1" ]; then
          $EDITOR $files
        else
          files=$(while read file; do basename $file; done <<< "$files" | fzf | while read file; do echo "${_NOTES_PATH}/$file"; done)
          if [ ! -z "$files" ]; then
            $EDITOR $files
          fi
        fi
      fi
    ;;
    *)
      >&2 echo "note [search|last]"
      exit 1
    ;;
  esac

  exit
fi

file=$(mktemp)
mv "$file"{,.md}
file="${file}.md"
mtime_in=$(date -r "$file" "+%s")
if ${EDITOR:-/usr/bin/vim} $file; then
  mtime_out=$(date -r "$file" "+%s")
  if [ $mtime_in -eq $mtime_out ]; then
    >&2 echo 'No changes to file. Discarding note.'
    rm $file
    exit 1
  fi
else
  >&2 echo '$EDITOR returned a non-zero exit code. Discarding note.'
  rm $file
  exit 1
fi

slug=$(sed '/[^[:blank:]]/q;d' < "$file"  |
      sed -e 's/[^a-zA-Z0-9]/-/g'         |
      sed -E 's/[\-]+/-/g'                |
      sed -e 's/^-//g'                    |
      sed -e 's/-$//g'                    |
      tr '[[:upper:]]' '[[:lower:]]')

dest="${_NOTES_PATH}/$(date -r "$file" "+%Y%m%d")-${slug:-untitled-note}"
suffix=""
while [ -e "${dest}${suffix}.md" ]; do
  suffix=$((${suffix:-0} - 1))
done

mv "$file" "${dest}${suffix}.md"
echo "Stored note at \"${dest}${suffix}.md\"."
