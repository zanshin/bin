#!/bin/bash
set -e
set -o pipefail

(head "$1" && echo "---" && tail "$1") | less
