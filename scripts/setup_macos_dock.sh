#!/usr/bin/env bash

if [ "$(uname)" != "Darwin" ]; then
	echo "This script is only for MacOS"
	exit 1
fi

# Setup MacOS Dock
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock tilesize -int 50
defaults write com.apple.dock largesize -int 64
defaults write com.apple.dock magnification -bool false
defaults write com.apple.dock orientation -string "bottom"
defaults write com.apple.dock mineffect -string ""
defaults write -g NSAutomaticWindowAnimationsEnabled -bool false

if ! command -v dockutil &>/dev/null; then
	echo "dockutil is not installed. Installing..."
	brew install dockutil
fi

dockutil --remove all

dockutil --add "/System/Applications/Mail.app/"
dockutil --add "/System/Applications/Messages.app/"
dockutil --add "/Applications/WezTerm.app"
dockutil --add "/Applications/Obsidian.app"
dockutil --add "/Applications/Zen.app"
dockutil --add "/System/Applications/System Settings.app"

# Restart the Dock to apply changes
killall Dock
