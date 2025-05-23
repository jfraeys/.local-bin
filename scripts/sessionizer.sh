#!/usr/bin/env bash

# Define constants
FZF_THEME="$HOME/.local/bin/scripts/fzf_theme"
LS_OPTS="-la --color=always"

# List of directories to include in the search
INCLUDED_DIRS=(
	"$HOME/.dotfiles"
	"$HOME/Documents"
	"$HOME/.local/bin"
	"$HOME/Google Drive/My Drive"
)

# Function to handle cleanup on keyboard interrupt or stop
cleanup() {
	echo "Interrupt detected. Cleaning up..."

	if pgrep -x tmux >/dev/null && [[ -n "$TMUX" ]]; then
		local original_session
		original_session=$(tmux list-sessions -F "#{session_name}" | tail -n 1)
		tmux switch-client -t "$original_session"
	elif command -v wezterm >/dev/null && wezterm --version | grep -q "wezterm"; then
		local tab_id
		tab_id=$(wezterm cli list | tail -n 1 | awk '{print $2}')
		wezterm cli activate-tab --tab-id "$tab_id"
	fi

	exit 0
}

# Trap the SIGINT (Ctrl+C) and SIGTSTP (Ctrl+Z) signals to handle cleanup
trap cleanup SIGINT SIGTSTP

# Function to find and deduplicate directories
find_directories() {
	local finder="$1"
	local include_params=("${@:2}")

	# Use a single call to find directories, optimizing the process
	"$finder" -H --min-depth 1 --max-depth 3 --type d . "${include_params[@]}" | sort -u
}

# Function to search and select directories using a fuzzy finder
search_dirs() {
	local finder="$1"
	local fuzzy_finder="$2"
	local include_params=("${INCLUDED_DIRS[@]}")

	local all_dirs
	all_dirs=$(find_directories "$finder" "${include_params[@]}")

	local selected
	selected=$(
		echo "$all_dirs" | "$fuzzy_finder" "$($FZF_THEME)" --cycle \
			--preview "if command -v eza >/dev/null; then eza $LS_OPTS --group-directories-first {}; else ls $LS_OPTS {}; fi"
	)

	if [ -n "$selected" ]; then
		echo "$selected"
	else
		echo "No directory selected. Exiting." >&2
		return 1
	fi
}

# Function to handle terminal multiplexer or tab management
handle_terminal() {
	local selected="$1"
	local selected_name

	selected_name=$(basename "$selected" | tr '.' '_')
	local full_path="${selected/#\~/$HOME}"

	if pgrep -x tmux >/dev/null && [[ -n "$TMUX" ]]; then
		if ! tmux has-session -t="$selected_name" 2>/dev/null; then
			tmux new-session -ds "$selected_name" -c "$selected"
		fi
		tmux switch-client -t "$selected_name"
	elif command -v wezterm >/dev/null && wezterm --version | grep -q "wezterm"; then
		local workspace_exists
		workspace_exists=$(wezterm cli list-workspaces | grep -w "$selected_name")

		if [[ -z $workspace_exists ]]; then
			wezterm cli create-workspace --name "$selected_name" --cwd "$full_path" # Create a new workspace
		fi
		wezterm cli switch-to-workspace --name "$selected_name"
	else
		echo "Warning: No terminal multiplexer detected (tmux or WezTerm)." >&2
		exit 1
	fi
}

# Main function to coordinate the script
main() {
	local selected

	if command -v sk >/dev/null && sk --version >/dev/null 2>&1; then
		selected=$(search_dirs "fd" "sk")
	elif command -v fzf >/dev/null && fzf --version >/dev/null 2>&1; then
		selected=$(search_dirs "fd" "fzf")
	else
		echo "Warning: No fuzzy finder program detected (fzf or sk). Install one or use command line arguments." >&2
		exit 1
	fi

	if [[ -n "$selected" ]]; then
		handle_terminal "$selected"
	fi
}

# Execute the main function
main
