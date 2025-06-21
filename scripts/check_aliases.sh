#!/usr/bin/env bash

# Safer aliases that depend on tools being available

# Use Neovim if available
if command -v nvim >/dev/null; then
	alias v="nvim"
fi

# Enhanced ls with eza
if command -v eza >/dev/null; then
	alias ls='eza --group-directories-first --color=auto'
	alias la='eza -a --group-directories-first --color=auto'
	alias ll='eza -lh --group-directories-first --color=auto'
	alias lla='eza -la --group-directories-first --color=auto'
	alias l='eza --classify'
	alias lt='eza -lt modified --sort newest'
	alias lS='eza -lS --group-directories-first --color=auto'
	alias tree='eza --tree --level=3'
	alias lg='eza --git'
fi

# Bat for pretty `cat` and help
if command -v bat >/dev/null; then
	# Define a function instead of aliasing inside same unit
	cat() {
		command bat --paging=never "$@"
	}

	bathelp() {
		bat --plain --language=help
	}

	help() {
		"$@" --help 2>&1 | bathelp
	}

	# Global aliases for help text
	alias -g :h='-h 2>&1 | bat --language=help --style=plain'
	alias -g :help='--help 2>&1 | bat --language=help --style=plain'
fi
