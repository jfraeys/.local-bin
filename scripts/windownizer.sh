#!/usr/bin/env bash

# Extract the base name of the branch
branch_name=$(basename "$1")
clean_name=$(echo "$branch_name" | tr "./" "__")
tmux_running=$(pgrep tmux)

# Detect if we are in a tmux session or using WezTerm
if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
    # tmux specific logic
    session_name=$(tmux display-message -p "#S")
    target="$session_name:$clean_name"

    if ! tmux select-window -t "$target" 2>/dev/null; then
        tmux neww -dn "$clean_name"
    fi

    shift
    if [ $# -gt 0 ]; then
        tmux send-keys -t "$target" "$*" Enter
    fi

elif command -v wezterm >/dev/null && wezterm --version | grep -q "wezterm"; then
    # WezTerm specific logic
    pane_id=$(wezterm cli list | grep "$clean_name" | awk '{print $1}')

    if [ -z "$pane_id" ]; then
        pane_id=$(wezterm cli spawn --new-tab --title "$clean_name" | awk '{print $1}')
    else
        wezterm cli activate-tab --pane-id "$pane_id"
    fi

    shift
    if [ $# -gt 0 ]; then
        wezterm cli send-text --pane-id "$pane_id" "$*"
        wezterm cli send-text --pane-id "$pane_id" "\n"
    fi

else
    echo "Warning: No terminal multiplexer detected (tmux or WezTerm)."
fi

