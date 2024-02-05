#!/usr/bin/env zsh

# patched versions for CVE-2023-4863: 22.3.24, 24.8.3, 25.8.1, 26.2.1
mdfind "kind:app" 2>/dev/null | sort -u | while read app;
do
  filename="$app/Contents/Frameworks/Electron Framework.framework/Electron Framework"
  if [[ -f $filename ]]; then
    echo "App Name:          $(basename ${app})"

    electronVersion=$(strings "$filename" | grep "Chrome/" | grep -i Electron | grep -v '%s' | sort -u | cut -f 3 -d '/')
    echo "Electron Version:  $electronVersion"

    echo -n "File Name:         $filename "
    echo -e "\n"
  fi
done
