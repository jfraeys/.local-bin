#!/usr/bin/env bash

DOTFILES_REPO="git@github.com:jfraeys/dotfiles.git"
DOTFILES_DIR="${XDG_HOME:-$HOME}/dotfiles"

# Function to check if a command is available
command_exists() {
	command -v "$1" >/dev/null 2>&1
}

# Function to perform package manager updates and upgrades
update_and_upgrade() {
	local package_manager=$1
	case $package_manager in
	"brew")
		echo "Updating and upgrading Homebrew..."
		brew update && brew upgrade
		;;
	"apt-get")
		echo "Updating package list and upgrading..."
		sudo apt-get update && sudo apt-get upgrade -y
		;;
	"yum")
		echo "Updating package list and upgrading..."
		sudo yum check-update && sudo yum update -y
		;;
	*)
		echo "Unsupported package manager: $package_manager"
		exit 1
		;;
	esac
}

# Function to perform cleanup tasks
cleanup() {
	local package_manager=$1
	case $package_manager in
	"brew")
		echo "Cleaning up..."
		brew cleanup
		;;
	"apt-get")
		echo "Cleaning up..."
		sudo apt-get autoremove -y && sudo apt-get clean
		;;
	"yum")
		echo "Cleaning up..."
		sudo yum clean all
		;;
	esac
}

# Function to install a single dependency
install_dependency() {
	local package_manager=$1
	local dependency=$2
	case $package_manager in
	"brew")
		brew install "$dependency"
		;;
	"apt-get")
		sudo apt-get install -y "$dependency"
		;;
	"yum")
		sudo yum install -y "$dependency"
		;;
	esac
}

# Function to install dependencies based on the package manager
install_dependencies() {
	local package_manager=$1
	shift

	update_and_upgrade "$package_manager"

	echo "Installing dependencies..."
	for dependency in "$@"; do
		echo "Installing $dependency..."
		install_dependency "$package_manager" "$dependency"
		INSTALLED_DEPENDENCIES+=("$dependency ($package_manager)")
	done

	cleanup "$package_manager"
}

# Function to install dependencies from a list
install_dependency_list() {
	local package_manager=$1
	local dependencies_file=$2

	update_and_upgrade "$package_manager"

	echo "Installing dependencies from list..."
	while IFS=, read -r dependency link_or_path; do
		if [ -n "$link_or_path" ]; then
			echo "Installing $dependency from $link_or_path"
			if [[ "$link_or_path" =~ ^http ]]; then
				case $package_manager in
				"brew") brew install "$link_or_path" ;;
				"apt-get") wget "$link_or_path" -O /tmp/"$dependency".deb && sudo dpkg -i /tmp/"$dependency".deb ;;
				"yum") wget "$link_or_path" -O /tmp/"$dependency".rpm && sudo yum localinstall -y /tmp/"$dependency".rpm ;;
				esac
			else
				case $package_manager in
				"brew") brew install "$link_or_path" ;;
				"apt-get") sudo dpkg -i "$link_or_path" ;;
				"yum") sudo yum localinstall -y "$link_or_path" ;;
				esac
			fi
		else
			echo "Installing $dependency from default repository"
			install_dependency "$package_manager" "$dependency"
		fi
		INSTALLED_DEPENDENCIES+=("$dependency ($package_manager)")
	done <"$dependencies_file"

	cleanup "$package_manager"
}

# Function to determine the package manager and set it globally
set_package_manager() {
	if [ "$(uname)" == "Darwin" ]; then
		if ! command_exists brew; then
			echo "Homebrew is not installed. Installing Homebrew..."
			/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
		fi
		PACKAGE_MANAGER="brew"
	elif [ "$(uname)" == "Linux" ]; then
		if command_exists apt-get; then
			PACKAGE_MANAGER="apt-get"
		elif command_exists yum; then
			PACKAGE_MANAGER="yum"
		else
			echo "Unsupported package manager. Exiting."
			exit 1
		fi
	else
		echo "Unsupported operating system $(uname). Exiting."
		exit 1
	fi
}

# Function to handle auto-updates for Homebrew
handle_auto_update() {
	if [ "$ENABLE_AUTO_UPDATE" == true ] && [ "$PACKAGE_MANAGER" == "brew" ]; then
		if command_exists brew; then
			brew autoupdate --start --upgrade --cleanup
		fi
	fi
}

# Setup Mac OS dock
setup_macos_dock() {
	if [ "$(uname)" != "Darwin" ]; then
		echo "This function is only supported on macOS. Exiting."
		exit 1
	fi

	defaults write com.apple.dock autohide -bool true
	defaults write com.apple.dock tilesize -int 36
	defaults write com.apple.dock largesize -int 64
	defaults write com.apple.dock magnification -bool true
	defaults write com.apple.dock largesize -int 64
	defaults write com.apple.dock orientation -string "left"
	defaults write com.apple.dock mineffect -string "scale"
}

# Function to install and configure zsh
install_and_configure_shell() {
	if ! command_exists zsh && [ "$(uname)" == "Darwin" ]; then
		install_dependencies "$PACKAGE_MANAGER" zsh
		# Replaced by zinit in .zshrc
		# if [ ! -d "$HOME/.oh-my-zsh" ]; then
		#     git clone https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
		# fi
		if [ "$SHELL" != "$(command -v zsh)" ]; then
			chsh -s "$(command -v zsh)"
		fi

		exec zsh -l
	fi
}

# Function to install essential tools
install_essential_tools() {
	if ! command_exists curl; then
		install_dependencies "$PACKAGE_MANAGER" curl
	fi
	if ! command_exists unzip; then
		install_dependencies "$PACKAGE_MANAGER" unzip
	fi
	if ! command_exists git; then
		install_dependencies "$PACKAGE_MANAGER" git fd ripgrep fzf tree
	fi
	if ! command_exists nvim; then
		install_dependencies "$PACKAGE_MANAGER" neovim
	fi
}

# Function to install Go
install_go() {
	case $PACKAGE_MANAGER in
	"brew") install_dependencies "$PACKAGE_MANAGER" go ;;
	"apt-get" | "yum") install_dependencies "$PACKAGE_MANAGER" golang ;;
	*)
		echo "Unsupported package manager: $PACKAGE_MANAGER"
		exit 1
		;;
	esac
}

# Function to install Python and Poetry
install_python() {
	# Check if "global" argument is passed
	GLOBAL_INSTALL=true
	if [[ "$1" == "local" ]]; then
		GLOBAL_INSTALL=false
	fi

	# Install pyenv if it's not already installed
	if ! command -v pyenv >/dev/null 2>&1; then
		echo "Installing pyenv..."
		curl https://pyenv.run | bash

		# Set up pyenv in the current shell session
		export PATH="$HOME/.pyenv/bin:$PATH"
		eval "$(pyenv init --path)"
		eval "$(pyenv init -)"
		eval "$(pyenv virtualenv-init -)"
	fi

	# Ensure Python 3.7+ is installed via pyenv
	REQUIRED_VERSION="3.7.0"
	# Function to check if the installed Python version is at least the required version
	check_python_version() {
		INSTALLED_VERSION=$(python -c "import sys; print('{}.{}'.format(sys.version_info.major, sys.version_info.minor))")

		if [[ $(printf '%s\n' "$REQUIRED_VERSION" "$INSTALLED_VERSION" | sort -V | head -n 1) == "$REQUIRED_VERSION" ]]; then
			echo "Python version $INSTALLED_VERSION is installed and meets the requirement."
		else
			echo "Python version is less than $REQUIRED_VERSION. Exiting."
			exit 1
		fi
	}

	check_python_version

	# Set Python version globally or locally
	if [[ "$GLOBAL_INSTALL" == true ]]; then
		echo "Setting Python $REQUIRED_VERSION as the global version..."
		pyenv global "$REQUIRED_VERSION"
	else
		echo "Setting Python $REQUIRED_VERSION as the local version..."
		pyenv local "$REQUIRED_VERSION"
	fi

	# Rehash pyenv to make the new version available
	pyenv rehash

	# Install Poetry using the pyenv-installed Python
	echo "Installing Poetry..."
	curl -sSL https://install.python-poetry.org | python3 -
}

# Function to install all programming languages
install_programming_languages() {
	install_go
	install_python global # Pass "global" as an argument to set Python globally
}

# Function to install MesloLGS Nerd Font
install_meslolgs_nerd_font() {
	if [ ! -f "$HOME/.local/share/fonts/MesloLGS NF Regular.ttf" ]; then
		mkdir -p ~/.local/share/fonts
		cd ~/.local/share/fonts || return
		curl -fLo "MesloLGS NF Regular.ttf" https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Meslo.zip
		unzip Meslo.zip -d meslo
		mv meslo/*.ttf ~/.local/share/fonts/
		rm -rf Meslo.zip meslo
		fc-cache -f -v
	fi
}

# Function to display installed dependencies
show_installed_dependencies() {
	echo "Installed dependencies:"
	for dependency in "${INSTALLED_DEPENDENCIES[@]}"; do
		echo "  - $dependency"
	done
}

# Ensure HomeBrew is installed
ensure_homebrew() {
	if ! command_exists brew; then
		echo "Installing Homebrew..."
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	fi
	echo "Updating Homebrew..."
	brew update
}

# Function to start shell
start_shell() {
	if command -v zsh &>/dev/null; then
		zsh
	elif command -v bash &>/dev/null; then
		bash
	elif command -v fish &>/dev/null; then
		fish
	else
		echo "Neither zsh nor bash is installed. Please install one of them manually."
	fi
}

# Default values for flags
ENABLE_AUTO_UPDATE=true
DEPENDENCIES_FILE=""
ADDITIONAL_DEPENDENCIES=()
INSTALLED_DEPENDENCIES=()

# Parse command-line arguments
while [[ "$#" -gt 0 ]]; do
	case $1 in
	-a | --disable-auto-update)
		ENABLE_AUTO_UPDATE=false
		shift
		;;
	-d | --dependencies)
		DEPENDENCIES_FILE="$2"
		shift 2
		;;
	*)
		ADDITIONAL_DEPENDENCIES+=("$1")
		shift
		;;
	esac
done

# Main script execution
set_package_manager
handle_auto_update
install_essential_tools
install_and_configure_shell
install_programming_languages

# Install MesloLGS Nerd Font
install_meslolgs_nerd_font

# Install dependencies from provided file if specified
if [ -n "$DEPENDENCIES_FILE" ]; then
	install_dependency_list "$PACKAGE_MANAGER" "$DEPENDENCIES_FILE"
fi

# Install additional dependencies provided as arguments
if [ "${#ADDITIONAL_DEPENDENCIES[@]}" -gt 0 ]; then
	install_dependencies "$PACKAGE_MANAGER" "${ADDITIONAL_DEPENDENCIES[@]}"
fi

show_installed_dependencies
start_shell
