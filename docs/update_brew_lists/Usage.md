## [update_brew_lists](../../scripts/update_brew_lists)

This script automates the process of updating Homebrew and associated package lists. It can be used to keep track of installed packages and update them as needed.

## Usage

### Update Brew and Cask Lists

Run the following command to update both Brew and Cask lists:

```bash
./update_brew_lists
```

This command will update the lists and commit the changes to Git.

#### Install Homebrew and Packages

If Homebrew is not installed, you can use the following command to install it and the packages listed in the Brew and Cask lists:

```bash
./update_brew_lists --install
```

#### Update Brew Lists Only

To update only the Brew lists without committing the changes to Git, you can use:

```bash
./update_brew_lists --update-brew-lists
```

#### Save Lists to Custom Directories
You can specify custom directories to save the Brew and Cask lists:

```bash
./update_brew_lists --save-brew-dir
./update_brew_lists --save-cask-dir /path/to/custom/dir
```

Note: Make sure to create the custom directories before running these commands.

#### Configuration
The script uses the following default directories:

- Brew List Directory: $HOME/.local/bin/.brew_lists
- Cask List Directory: $HOME/.local/bin/.brew_lists

