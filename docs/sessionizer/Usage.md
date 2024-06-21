## [sessionizer](../../sessionizer)

This script simplifies the management of tmux sessions or WezTerm windows by providing an interactive interface to create or switch between sessions. If a session doesn't exist for a selected directory, it creates a new tmux session or a new WezTerm tab with the selected directory as the working directory.

### Usage

Run the script without any arguments to interactively select a directory using `fzf` or `sk`. Alternatively, you can provide a directory path as an argument to quickly switch to or create a tmux session or WezTerm tab for that directory.

```bash
./sessionizer [directory]
```

- If a single argument is provided, the script will use it as the selected directory.
- If no argument is provided, the script will use `fd` and `fzf` to interactively select a directory.

### Example Usage

1. Interactively select a directory using `fzf` or `sk`:

    ```bash
    ./sessionizer
    ```

2. Quickly switch to or create a session for a specific directory:

    ```bash
    ./sessionizer ~/projects/my_project
    ```

The script checks whether tmux or WezTerm is already running or if there is an existing tmux session or WezTerm tab for the selected directory. If not, it creates a new session; otherwise, it switches to the existing session.

