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
