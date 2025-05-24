#!/usr/bin/env bash

# Make sure HOMEBREW_PREFIX is set, else fallback to /opt/homebrew (common default on macOS ARM)
BREW_PREFIX="${HOMEBREW_PREFIX:-/opt/homebrew}"
BREW_CMD="$BREW_PREFIX/bin/brew"

BREW_LIST_DIR="$HOME/.local/bin/.brew_lists"
BREW_LIST="$BREW_LIST_DIR/brew_list.txt"
CASK_LIST="$BREW_LIST_DIR/cask_list.txt"
NEW_BREW_LIST="$BREW_LIST_DIR/brew_list.new.txt"
NEW_CASK_LIST="$BREW_LIST_DIR/cask_list.new.txt"

# Function to check if the lists are different
# Returns 0 if different, 1 if same
are_lists_different() {
	diff -q "$1" "$2" >/dev/null 2>&1
	return $((!$?)) # invert diff exit code because diff returns 0 if files same
}

# Function to update the brew and cask lists
update_lists() {
	echo "Updating brew list..."
	"$BREW_CMD" list --formula >"$NEW_BREW_LIST"
	chmod 664 "$NEW_BREW_LIST"

	echo "Updating cask list..."
	"$BREW_CMD" list --cask >"$NEW_CASK_LIST"
	chmod 664 "$NEW_CASK_LIST"
}

# Function to install Homebrew and packages
install_packages() {
	# Install Homebrew if not installed
	if ! command -v "$BREW_CMD" &>/dev/null; then
		echo "Installing Homebrew..."
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	fi

	# Install brew packages
	if [ -s "$BREW_LIST" ]; then
		echo "Installing brew packages..."
		xargs "$BREW_CMD" install <"$BREW_LIST"
		echo "Brew packages installed successfully."
	fi

	# Install cask packages
	if [ -s "$CASK_LIST" ]; then
		echo "Installing cask packages..."
		xargs "$BREW_CMD" install --cask <"$CASK_LIST"
		echo "Cask packages installed successfully."
	fi
}

# Function to save lists to specified directories
save_lists() {
	echo "Saving updated lists to specified directories..."

	mv "$NEW_BREW_LIST" "$BREW_LIST"
	mv "$NEW_CASK_LIST" "$CASK_LIST"

	echo "Lists saved successfully."
}

# Function to commit changes to Git
commit_to_git() {
	current_dir=$PWD
	cd "$HOME/.local/bin" || exit
	git pull
	git add "$BREW_LIST" "$CASK_LIST"
	git commit -m "Update brew lists" || echo "No changes to commit"
	git push origin main
	cd "$current_dir" || exit
}

# Check command-line arguments
while [[ $# -gt 0 ]]; do
	case "$1" in
	--install)
		install_packages
		exit 0
		;;
	--save-brew-dir)
		shift
		# This flag doesn't make sense in current script, remove or implement logic
		;;
	--save-cask-dir)
		shift
		CASK_LIST_DIR="$1"
		;;
	*)
		echo "Invalid argument: $1"
		exit 1
		;;
	esac
	shift
done

# Ensure brew list directory exists
if [ -n "$BREW_LIST_DIR" ] && [ ! -d "$BREW_LIST_DIR" ]; then
	mkdir -p "$BREW_LIST_DIR"
fi

# Ensure cask list directory exists
if [ -n "$CASK_LIST_DIR" ] && [ ! -d "$CASK_LIST_DIR" ]; then
	mkdir -p "$CASK_LIST_DIR"
fi

# Update the lists
update_lists

# Check if the lists have changed
if are_lists_different "$NEW_BREW_LIST" "$BREW_LIST" || are_lists_different "$NEW_CASK_LIST" "$CASK_LIST"; then
	# Lists have changed, save the updated lists
	save_lists

	# Commit changes to Git
	commit_to_git
else
	echo "No changes in brew or cask lists detected."
fi
