#!/usr/bin/env bash
set -euo pipefail

CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"
STARSHIP_CONFIG=$(realpath "$CONFIG_DIR/starship.toml")

if [[ ! -f "$STARSHIP_CONFIG" ]]; then
	echo "Error: starship.toml not found at $STARSHIP_CONFIG" >&2
	exit 1
fi

detect_appearance() {
	if [[ "$OSTYPE" == "darwin"* ]]; then
		defaults read -g AppleInterfaceStyle 2>/dev/null | grep -qi "Dark" && echo "dark" || echo "light"
	elif command -v gsettings >/dev/null 2>&1; then
		gsettings get org.gnome.desktop.interface color-scheme 2>/dev/null | grep -qi 'dark' && echo "dark" || echo "light"
	else
		echo "dark"
	fi
}

# Determine target palette
if [[ $# -eq 1 ]]; then
	target_palette="$1"
else
	case "$(detect_appearance)" in
	dark) target_palette="monokai_pro" ;;
	light) target_palette="solarized_light" ;;
	esac
fi

# Extract current palette from config
current_palette=$(awk -F'=' '/^palette/ {gsub(/[[:space:]"]/, "", $2); print $2}' "$STARSHIP_CONFIG")

# Compare and update if necessary
if [[ "$current_palette" == "$target_palette" ]]; then
	echo "Starship palette already set to '$target_palette'. No changes made."
	exit 0
fi

# Update
if command -v sd >/dev/null 2>&1; then
	sd 'palette\s*=.*' "palette = \"$target_palette\"" "$STARSHIP_CONFIG"
else
	SED_OPTS=()
	[[ "$OSTYPE" == "darwin"* ]] && SED_OPTS=(-i '')
	sed "${SED_OPTS[@]}" "s/palette *=.*/palette = \"$target_palette\"/" "$STARSHIP_CONFIG"
fi

echo "Updated Starship palette to '$target_palette' in $STARSHIP_CONFIG"
