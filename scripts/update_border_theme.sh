#!/usr/bin/env bash

set -euo pipefail

CONFIG_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/aerospace/aerospace.toml"

if [[ ! -f "$CONFIG_FILE" ]]; then
	echo "Error: Aerospace config not found at $CONFIG_FILE" >&2
	exit 1
fi

detect_appearance() {
	defaults read -g AppleInterfaceStyle 2>/dev/null | grep -qi "Dark" && echo "dark" || echo "light"
}

# Allow override
if [[ $# -eq 1 ]]; then
	mode="$1"
else
	mode="$(detect_appearance)"
fi

# Set target border config per mode
if [[ "$mode" == "dark" ]]; then
	new_border_line='borders active_color=0xffe6e8eb inactive_color=0xff3a3f4b width=5.0'
elif [[ "$mode" == "light" ]]; then
	new_border_line='borders active_color=0xff002b36 inactive_color=0xff93a1a1 width=5.0'
else
	echo "Invalid mode: $mode" >&2
	exit 1
fi

# Use sd if available, fallback to sed
if command -v sd >/dev/null 2>&1; then
	sd '^borders .*' "$new_border_line" "$CONFIG_FILE"
else
	SED_OPTS=()
	[[ "$OSTYPE" == "darwin"* ]] && SED_OPTS=(-i '')
	sed "${SED_OPTS[@]}" "s/^borders .*/$new_border_line/" "$CONFIG_FILE"
fi

eval "${new_border_line}"
