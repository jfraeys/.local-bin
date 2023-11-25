## .local-bin

This repository contains a collection of binary files that I use for various purposes.

## Binary Files

- `aactivator.py`
- `setup_config`
- `tmux_sessionizer`
- `tmux_windownizer`
- `update_brew_lists`

## Usage

These binary files serve specific functions in my development environment.

### `update_brew_lists`

**Subtitle: A Utility for Managing Homebrew and Homebrew Cask Packages**

`update_brew_lists` is a utility script to manage and update lists of Homebrew and Homebrew Cask packages. It's particularly useful for maintaining a record of installed packages and automating the installation process on new machines.

#### Getting Started

1. Clone the repository and navigate to the `.local-bin` directory.

    ```bash
    git clone https://github.com/jfraeys/.local-bin.git ~/.local/bin
    cd ~/.local/bin
    ```

2. Run the `update_brew_lists` script without any arguments to update the Homebrew and Homebrew Cask lists.

    ```bash
    ./update_brew_lists
    ```

#### Additional Options

- `--install`: Install Homebrew if not already installed, and install the listed packages.
  
    ```bash
    ./update_brew_lists --install
    ```

- `--save-brew-dir` and `--save-cask-dir`: Save the updated lists to specific directories.
  
    ```bash
    ./update_brew_lists --save-brew-dir ~/my_custom_brew_lists --save-cask-dir ~/my_custom_cask_lists
    ```

#### Example Usage

- Update and install packages:

    ```bash
    ./update_brew_lists --install
    ```

- Update lists and save them to custom directories:

    ```bash
    ./update_brew_lists --save-brew-dir ~/my_custom_brew_lists --save-cask-dir ~/my_custom_cask_lists
    ```

Feel free to customize further based on your specific use case and preferences.
