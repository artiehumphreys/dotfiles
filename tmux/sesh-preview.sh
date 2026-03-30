#!/usr/bin/env bash
dir=$(tmux display-message -t "$1" -p "#{pane_current_path}" 2>/dev/null)
if [ -n "$dir" ]; then
    ls -1 "$dir" 2>/dev/null
else
    echo "no preview"
fi
