#!/usr/bin/env bash
set -e

echo "==> Setting up MacTeX and Poppler..."
echo "==> Checking for Homebrew..."
if ! command -v brew &>/dev/null; then
	echo "Homebrew not found. Install it from https://brew.sh/"
	exit 1
fi

brew update
brew install --cask mactex-no-gui
brew install poppler

TEX_BIN="/Library/TeX/texbin"
if [[ ":$PATH:" != *":$TEX_BIN:"* ]]; then
	echo "export PATH='/Library/TeX/texbin:$PATH'" >>~/.zprofile
	export PATH="/Library/TeX/texbin:$PATH"
fi

echo -n "pdflatex: "
pdflatex --version | head -n1
echo -n "xelatex: "
xelatex --version | head -n1
echo -n "latexmk: "
latexmk -v | head -n1
echo -n "pdfinfo: "
pdfinfo -v | head -n1

echo "✅ Done."
