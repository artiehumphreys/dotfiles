#!/usr/bin/env bash
export PATH=/opt/homebrew/bin:$PATH
echo "sesh: $(which sesh)" >> /tmp/sesh-debug.log
echo "fzf-tmux: $(which fzf-tmux)" >> /tmp/sesh-debug.log

session=$(sesh list | fzf-tmux -p 55%,60% \
    --no-sort --reverse --ansi \
    --border-label ' sesh ' \
    --prompt '  ' \
    --header '  ^a all ^t tmux ^g configs ^x zoxide ^d tmux kill ^f find' \
    --preview '~/.config/tmux/sesh-preview.sh {}' \
    --preview-window 'right:50%' \
    --bind 'tab:down,btab:up' \
    --bind 'ctrl-a:change-prompt(  )+reload(sesh list --icons)' \
    --bind 'ctrl-t:change-prompt(  )+reload(sesh list -t --icons)' \
    --bind 'ctrl-g:change-prompt(  )+reload(sesh list -c --icons)' \
    --bind 'ctrl-x:change-prompt(  )+reload(sesh list -z --icons)' \
    --bind 'ctrl-f:change-prompt(  )+reload(fd -H -d 2 -t d -E .Trash . ~)' \
    --bind 'ctrl-d:execute(tmux kill-session -t {E..})+change-prompt(  )+reload(sesh list --icons)')

[[ -z "$session" ]] && exit 0
sesh connect "$session"
