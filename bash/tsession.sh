#!/usr/bin/env bash

# From https://github.com/ThePrimeagen/.dotfiles/blob/master/bin/.local/bin/tmux-sessionizer

set -e
set -o pipefail

# Need fzf installed
if ! command -v fzf &> /dev/null; then
    echo "fzf not installed."
    exit 1
fi

if [[ $# -eq 1 ]]; then
    selected=$1
else
  # Trailing slashes behave differently on Linux and MaxOS (BSD-based). I.e.,
  # `~/` will produce `//` in the resulting paths on MacOS. On Linux `~/` works
  # without a hitch
    selected=$(find ~/code ~ -mindepth 1 -maxdepth 1 -type d | fzf)
fi

if [[ -z "$selected" ]]; then
    exit 0
fi

selected_name=$(basename "$selected" | tr . _)
tmux_running=$(pgrep tmux) || true

if [[ -z $TMUX ]] && [[ -z "$tmux_running" ]]; then
    tmux new-session -s "$selected_name" -c "$selected"
    exit 0
fi

if ! tmux has-session -t "$selected_name" 2> /dev/null; then
    tmux new-session -ds "$selected_name" -c "$selected"
fi

if [[ -z $TMUX ]]; then
    tmux attach-session -t "$selected_name"
else
    tmux switch-client -t "$selected_name"
fi
