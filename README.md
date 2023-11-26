# .local-bin

Welcome to the .local-bin repository! This collection is carefully crafted to enhance and customize your development environment. Here's a detailed overview of its key components:

Binary Files
- aactivator.py: A powerful script designed to automate the sourcing of environments in an interactive shell. Activate it effortlessly by evaluating $(aactivator init) in your shell.
- tmux_sessionizer: This script simplifies the management of tmux sessions by providing an interactive interface to create or switch between sessions. If a session doesn't exist for a selected directory, it creates a new tmux session with the selected directory as the working directory.
- tmux_windownizer: This script is designed to streamline the process of sending commands to a specific tmux window. It takes a branch name (or any identifier) as an argument, creates a new window if it doesn't exist in the current tmux session, and sends the provided command to that window.
- update_brew_lists: This script automates the process of updating Homebrew and associated package lists. It can be used to keep track of installed packages and update them as needed.

## [setup_dev_environment.sh](setup_dev_environment.sh)

This script automates the setup of a development environment by installing essential tools, configuring common settings, and providing options for customization. It supports the following options:

- `-a` or `--disable-auto-update`: Disable Homebrew auto-updates.
- `-n` or `--disable-notification`: Disable notifications during setup.

**Usage:**

```bash
./setup_dev_environment.sh [-a|--disable-auto-update] [-n|--disable-notification]
```

## [aactivator.py](aactivator.py)

### Usage 
The aactivator.py script simplifies the activation and deactivation of environments in an interactive shell. Follow these steps to use it in your project:

### Example Usage 
Create an activation script (.activate.sh) in your project, which activates your environment. For example, in a Python project:

```bash
ln -vs venv/bin/activate .activate.sh
```

2. Create a deactivation script (.deactivate.sh) in your project, which deactivates your environment. For example:

```bash
echo deactivate > .deactivate.sh
```
3. In your Python project, if an environment is already active, it will not be re-activated. If a different project is activated, the previous project will be deactivated beforehand.

4. Run the following command in your shell to initialize aactivator:
```bash
eval "$(aactivator init)"
```
Now, whenever you navigate to your project directory, aactivator will ask before automatically sourcing environments. It will remember your preference for each project.

## [tmux_sessionizer.sh](tmux_sessionizer.sh)

This script simplifies the management of tmux sessions by providing an interactive interface to create or switch between sessions. If a session doesn't exist for a selected directory, it creates a new tmux session with the selected directory as the working directory.

### Usage 

Run the script without any arguments to interactively select a directory using `fzf`. Alternatively, you can provide a directory path as an argument to quickly switch to or create a session for that directory.

```bash
./tmux_sessionizer [directory]
```
- If a single argument is provided, the script will use it as the selected directory.
- If no argument is provided, the script will use fd and fzf to interactively select a directory.

### Example Usage 

1. Interactively select a directory using fzf:
```bash
./tmux_sessionizer
```

2. Quickly switch to or create a session for a specific directory:
```bash
./tmux_sessionizer ~/projects/my_project
```

The script checks whether tmux is already running or if there is an existing tmux session for the selected directory. If not, it creates a new session; otherwise, it switches to the existing session.

## [tmux_windownizer.sh](tmux_windownizer.sh) 

This script is designed to streamline the process of sending commands to a specific tmux window. It takes a branch name (or any identifier) as an argument, creates a new window if it doesn't exist in the current tmux session, and sends the provided command to that window.

### Usage 

Run the script with the branch name and the command you want to send:

```bash
./tmux_windownizer branch_name command_to_send
```

- `branch_name`: The branch name (or any identifier) for the target window.
- `command_to_send`: The command you want to send to the specified tmux window.

### Example Usage 

Assuming you have a tmux session named "my_session" and want to send a command to a window associated with the branch "feature/awesome-feature":
```bash
./tmux_windownizer feature/awesome-feature "your_command_here"
```

If the window for "feature/awesome-feature" doesn't exist in the "my_session" tmux session, the script creates a new window for it before sending the command.

## [update_brew_lists.sh](update_brew_lists.sh) 

This script automates the process of updating Homebrew and associated package lists. It can be used to keep track of installed packages and update them as needed.

## Usage 

### Update Brew and Cask Lists 

Run the following command to update both Brew and Cask lists:

```bash
./update_brew_lists.sh
```

This command will update the lists and commit the changes to Git.

#### Install Homebrew and Packages 

If Homebrew is not installed, you can use the following command to install it and the packages listed in the Brew and Cask lists:

```bash
./update_brew_lists.sh --install
```

#### Update Brew Lists Only 

To update only the Brew lists without committing the changes to Git, you can use:

```bash
./update_brew_lists.sh --update-brew-lists
```

#### Save Lists to Custom Directories 
You can specify custom directories to save the Brew and Cask lists:

```bash
./update_brew_lists.sh --save-brew-dir
./update_brew_lists.sh --save-cask-dir /path/to/custom/dir
```

Note: Make sure to create the custom directories before running these commands.

#### Configuration 
The script uses the following default directories:

- Brew List Directory: $HOME/.local/bin/.brew_lists
- Cask List Directory: $HOME/.local/bin/.brew_lists

Feel free to use this script to simplify sending commands to specific tmux windows based on branch names or other identifiers in your development workflow
