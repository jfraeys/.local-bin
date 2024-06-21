---
layout: default
title: .local-bin Documentation
nav_order: 1
---

# .local-bin Documentation

Welcome to the documentation for the `.local-bin` repository. This collection is designed to enhance and customize your development environment. Here's a quick overview of the key components:

## Binary Files

- [aactivator.py](aactivator/Usage.md): A powerful script designed to automate the sourcing of environments in an interactive shell. Activate it effortlessly by evaluating `$(aactivator init)` in your shell.
- [sessionizer](sessionizer/Usage.md): This script simplifies the management of tmux sessions by providing an interactive interface to create or switch between sessions. If a session doesn't exist for a selected directory, it creates a new tmux session with the selected directory as the working directory.
- [windonizer](windownizer/Usage.md): This script is designed to streamline the process of sending commands to a specific tmux window. It takes a branch name (or any identifier) as an argument, creates a new window if it doesn't exist in the current tmux session, and sends the provided command to that window.
- [update_brew_lists](update_brew_lists/Usage.md): This script automates the process of updating Homebrew and associated package lists. It can be used to keep track of installed packages and update them as needed.
- [setup_dev_env](setup_dev_env/Usage.md): This script automates the setup of a development environment by installing essential tools, configuring common settings, and providing options for customization. It supports the following options:
  - `-a` or `--disable-auto-update`: Disable Homebrew auto-updates.
  - `-n` or `--disable-notification`: Disable notifications during setup.
- [docker_check](docker_check/Usage.md): This script automates the process of ensuring Docker is installed and running before executing Docker-related commands. If Docker is not installed, it provides an option to install it via Homebrew.
- [add_yaml_header](add_yaml_header/Usage.md): This script ensures that YAML files within a specified directory contain the necessary `---` header. If a YAML file does not have the `---` header, the script adds it.
- [wzp](wzp/Usage.md): This script automates the process of starting a new Wezterm project. It allows you to select a project from a predefined list or specify a project name as an argument.

Feel free to use these scripts to simplify tasks and enhance your development workflow.

## Getting Started

If you're new to .local-bin, follow these steps to get started:

1. Clone the repository: `git clone https://github.com/your-username/.local-bin.git`
2. Navigate to the `.local-bin` directory: `cd .local-bin`
3. Explore the documentation sections to learn about each script and its usage.

Happy coding!

