#!/usr/bin/env bash

# Check if nvim is installed
if command -v nvim >/dev/null; then
    alias v="nvim"
fi

# Check if eza is installed
if command -v eza >/dev/null; then
    alias ls='eza --group-directories-first --color=auto'
    alias la='eza -la --group-directories-first --color=auto'
    alias ll='eza -l --group-directories-first --color=auto'
    alias lt='eza -lt modified --sort newest'
    alias lS='eza -lS --group-directories-first --color=auto'
    alias tree='eza --tree --level=3'
    alias lg='eza --git'
fi

# Check if bat is installed
if command -v bat >/dev/null; then
    alias cat="bat --paging=never"

    help() {
        "$@" --help 2>&1 | bathelp
    }
    alias bathelp="bat --plain --language=help"

    # Overwriting -h and --help with bat highlights
    alias -g :h='-h 2>&1 | bat --language=help --style=plain'
    alias -g :help='--help 2>&1 | bat --language=help --style=plain'
fi

