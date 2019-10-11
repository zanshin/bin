#!/bin/bash

if [ "$(ps ax | grep tunnel-start.sh | grep -vc grep)" -lt 1 ]; then
  sudo -u mhn /Users/mhn/bin/tunnel-start.sh &
fi
