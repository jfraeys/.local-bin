#!/usr/bin/env bash

# WezTerm Project - Start a new WezTerm profile
PROFILES_DIR="$HOME/.config/wezterm/profiles/"
FZF_THEME=$("$HOME"/.local/bin/scripts/fzf_theme.sh)
profile="default"

if [[ -z "$1" ]]; then
	# List all Lua files in the projects directory and prompt for selection
	profile=$(fd -d 1 -e lua -t f . "$PROFILES_DIR" --print0 | xargs -0 -n 1 basename | sed 's/\.lua$//' | fzf "$FZF_THEME" --cycle --no-info --layout=reverse)
else
	if [[ ! -e "$PROFILES_DIR/$1.lua" ]]; then
		echo "The profile file '$PROFILES_DIR/$1.lua' does not exist"
		exit 1
	fi
	profile="$1"
fi

if [[ -z $profile ]]; then
	echo "No profile selected"
	exit 1
fi

# Start WezTerm with the selected project profile
WZ_PROFILE="$profile" wezterm start --always-new-process >/dev/null 2>&1 &
