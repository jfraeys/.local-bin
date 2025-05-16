#!/usr/bin/env bash

set_fzf_theme() {
	local appearance="$1"

	# Detect the current system appearance (Light or Dark mode) for Linux and macOS
	if [[ -z "$appearance" ]]; then
		if [[ "$OSTYPE" == "darwin"* ]]; then
			# macOS
			appearance=$(defaults read -g AppleInterfaceStyle 2>/dev/null)
		elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
			# Linux (assuming GNOME)
			appearance=$(gsettings get org.gnome.desktop.interface gtk-theme 2>/dev/null)
		else
			# Default to Dark mode if the system is not recognized
			appearance="Dark"
		fi
	fi

	# Set FZF theme based on appearance
	if [[ $appearance == *"Dark"* || -n "$TMUX" ]]; then
		# Monokai (Dark Theme) with slight adjustments
		FZF_DEFAULT_OPTS="--color=bg+:#272822,bg:#272822,spinner:#ff669d,hl:#66d9ee,fg:#f8f8f2,header:#ff669d,info:#66d9ee,pointer:#a6e22e,marker:#a6e22e,fg+:#e8e8e3,prompt:#66d9ee,hl+:#66d9ee"
	else
		# Solarized Light with better contrast for readability
		FZF_DEFAULT_OPTS="--color=bg+:#fdf6e3,bg:#fdf6e3,spinner:#d33682,hl:#cb4b16,fg:#586e75,header:#d33682,info:#268bd2,pointer:#859900,marker:#859900,fg+:#002b36,prompt:#eee8d5,hl+:#b58900"
	fi

	echo "$FZF_DEFAULT_OPTS"
}

# Call the function if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
	set_fzf_theme "$1"
fi
