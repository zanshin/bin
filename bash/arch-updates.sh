#!/bin/bash
set -e
set -o pipefail

echo $(checkupdates | wc -l) > $HOME/.updatecount
