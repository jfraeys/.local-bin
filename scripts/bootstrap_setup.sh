#!/usr/bin/env bash
set -e

GH_USERNAME="jfrays"

# Dry run mode
DRY_RUN=false
if [[ "$1" == "--dry-run" ]]; then
	DRY_RUN=true
	echo "🧪 Dry run mode enabled: commands will be echoed but not executed."
fi

run() {
	echo "+ $*"
	if [[ "$DRY_RUN" == false ]]; then
		"$@"
	fi
}

run_shell() {
	echo "+ $*"
	if [[ "$DRY_RUN" == false ]]; then
		bash -c "$*"
	fi
}

# Install package manager tools
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
	run sudo apt update
	run sudo apt install -y git stow curl

elif [[ "$OSTYPE" == "darwin"* ]]; then
	run xcode-select --install
	run_shell "/bin/bash -c '$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)'"
	run brew install stow git curl
fi

# Clone dotfiles
run git clone "https://github.com/$GH_USERNAME/dotfiles.git" "$HOME/.dotfiles"
run bash -c "cd \"$HOME/.dotfiles\" && ./setup.sh"

# Setup dev scripts
run mkdir -p "$HOME/.local/bin/scripts"
run git clone "https://github.com/$GH_USERNAME/scripts.git" "$HOME/.local/bin/scripts"
run bash -c "cd \"$HOME/.local/bin/scripts\" && chmod +x setup_dev_env.sh && ./setup_dev_env.sh"
