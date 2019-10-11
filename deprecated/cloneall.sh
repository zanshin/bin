#!/bin/bash
set -e
set -o pipefail

# Script to get all repositories under a user from bitbucket
# Usage: cloneall.sh [username] [teamname]

#curl -u ${1}  https://api.bitbucket.org/1.0/users/${2} > repoinfo
curl -u "${1}"  https://api.bitbucket.org/1.0/users/"${1}" > repoinfo
for repo_name in $(grep \"name\" repoinfo | cut -f4 -d\")
do
  git clone ssh://git@bitbucket.org:"${2}"/"$repo_name"
done
