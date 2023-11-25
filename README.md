## .local-bin

This repository contains a collection of handy binary files and scripts for various purposes in my development environment.

### Binary Files

- `aactivator.py`
- `setup_config`
- `tmux_sessionizer`
- `tmux_windownizer`
- `update_brew_lists`

These binary files serve specific functions in my development environment.

### Scripts

#### `setup_dev_env`

**Subtitle: A Script for Setting Up a Developer Environment**

The `setup_dev_env` script automates the configuration of a developer environment by installing essential tools and setting up common configurations. This is particularly useful for quickly preparing a new development environment or ensuring consistency across multiple machines.

#### Getting Started

1. **Clone the Repository:**
    ```bash
    git clone https://github.com/jfraeys/.local-bin.git ~/.local/bin
    cd ~/.local/bin
    ```

2. **Run the Setup Script:**
    ```bash
    ./setup_dev_env
    ```

### What it Does

- Checks the operating system (macOS or Linux).
- Installs Homebrew (on macOS) or uses the system's package manager (on Linux).
- Clones or initializes the dotfiles repository (`~/.dotfiles`).
- Installs or updates Git, fd, ripgrep, fzf, tree, Zsh, Tmux, Go, Python, and pip.
- Sets up Oh-My-Zsh if not already present.
- Configures symbolic links for Zsh, Tmux, and Neovim.
- Sources configurations for the current session.
- Informs the user and waits for input before starting Zsh and Tmux.

### `update_brew_lists`

#### A Utility for Managing Homebrew and Homebrew Cask Packages**

`update_brew_lists` is a versatile script designed to manage and update lists of Homebrew and Homebrew Cask packages. It's particularly useful for keeping a record of installed packages and streamlining the installation process on new machines.

#### Getting Started

1. **Clone the Repository:**
    ```bash
    git clone https://github.com/jfraeys/.local-bin.git ~/.local/bin
    cd ~/.local/bin
    ```

2. **Update Brew Lists:**
    Run the script without arguments to update Homebrew and Homebrew Cask lists.
    ```bash
    ./update_brew_lists
    ```

#### Additional Options

- **Install Packages:**
    Use the `--install` flag to install Homebrew (if not installed) and the listed packages.
    ```bash
    ./update_brew_lists --install
    ```

- **Custom Save Directories:**
    Use `--save-brew-dir` and `--save-cask-dir` to save the updated lists to specific directories.
    ```bash
    ./update_brew_lists --save-brew-dir ~/my_custom_brew_lists --save-cask-dir ~/my_custom_cask_lists
    ```

#### Example Usage

- **Update and Install Packages:**
    ```bash
    ./update_brew_lists --install
    ```

- **Update Lists and Save to Custom Directories:**
    ```bash
    ./update_brew_lists --save-brew-dir ~/my_custom_brew_lists --save-cask-dir ~/my_custom_cask_lists
    ```

Feel free to customize further based on your specific use case and preferences.

