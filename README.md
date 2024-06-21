# .local-bin

[![GitHub Pages](https://img.shields.io/badge/GitHub_Pages-Documentation-blue?logo=github)](https://jfraeys.github.io/.local-bin/)
[![pages-build-deployment](https://github.com/jfraeys/.local-bin/actions/workflows/pages/pages-build-deployment/badge.svg?branch=main)](https://github.com/jfraeys/.local-bin/actions/workflows/pages/pages-build-deployment)

Welcome to the .local-bin repository! Find key components below to enhance your development environment. Below is a list of key components:

## Binary Files

- **[aactivator.py](aactivator.py):** A powerful script designed to automate the sourcing of environments in an interactive shell. Activate it effortlessly by evaluating `$(aactivator init)` in your shell.
- **[tmux_sessionizer](tmux_sessionizer):** This script simplifies the management of tmux sessions by providing an interactive interface to create or switch between sessions. If a session doesn't exist for a selected directory, it creates a new tmux session with the selected directory as the working directory.
- **[tmux_windownizer](tmux_windownizer):** This script is designed to streamline the process of sending commands to a specific tmux window. It takes a branch name (or any identifier) as an argument, creates a new window if it doesn't exist in the current tmux session, and sends the provided command to that window.
- **[update_brew_lists](update_brew_lists):** This script automates the process of updating Homebrew and associated package lists. It can be used to keep track of installed packages and update them as needed.
- **[setup_dev_environment.sh](setup_dev_env):** This script automates the setup of a development environment by installing essential tools, configuring common settings, and providing options for customization. It supports the following options:
  - `-a` or `--disable-auto-update`: Disable Homebrew auto-updates.
  - `-n` or `--disable-notification`: Disable notifications during setup.
- **[docker_check](docker_check):** This script automates the process of ensuring Docker is installed and running before executing Docker-related commands. If Docker is not installed, it provides an option to install it via Homebrew.
- **[add_yaml_header.sh](add_yaml_header.sh):** This script ensures that YAML files within a specified directory contain the necessary `---` header. If a YAML file does not have the `---` header, the script adds it.
- **[wzp](wzp):** This script automates the process of starting a new Wezterm project. It allows you to select a project from a predefined list or specify a project name as an argument.

## Documentation

For detailed documentation, please visit the [GitHub Pages site](https://jfraeys.github.io/.local-bin/).

Feel free to use this script collection to enhance your development workflow!

