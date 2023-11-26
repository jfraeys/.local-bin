# .local-bin

Welcome to the .local-bin repository! This collection is carefully crafted to enhance and customize your development environment. Here's a detailed overview of its key components:

## Table of Contents

- [aactivator.py](#aactivatorpy)
- [tmux_sessionizer](#tmux_sessionizer)
- [tmux_windownizer](#tmux_windownizer)
- [update_brew_lists](#update_brew_lists)
- [setup_dev_env](#setup_dev_env)

## Binary Files

- **[aactivator.py](docs/aactivator/Usage.md):** A powerful script designed to automate the sourcing of environments in an interactive shell. Activate it effortlessly by evaluating `$(aactivator init)` in your shell.
- **[tmux_sessionizer](docs/tmux_sessionizer/Usage.md):** This script simplifies the management of tmux sessions by providing an interactive interface to create or switch between sessions. If a session doesn't exist for a selected directory, it creates a new tmux session with the selected directory as the working directory.
- **[tmux_windownizer](docs/tmux_windownizer/Usage.md):** This script is designed to streamline the process of sending commands to a specific tmux window. It takes a branch name (or any identifier) as an argument, creates a new window if it doesn't exist in the current tmux session, and sends the provided command to that window.
- **[update_brew_lists](docs/update_brew_lists/Usage.md):** This script automates the process of updating Homebrew and associated package lists. It can be used to keep track of installed packages and update them as needed.
- **[setup_dev_environment.sh](docs/setup_dev_env/Usage.md):** This script automates the setup of a development environment by installing essential tools, configuring common settings, and providing options for customization. It supports the following options:
  - `-a` or `--disable-auto-update`: Disable Homebrew auto-updates.
  - `-n` or `--disable-notification`: Disable notifications during setup.

Feel free to use this script to simplify sending commands to specific tmux windows based on branch names or other identifiers in your development workflow.

