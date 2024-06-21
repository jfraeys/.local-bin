## [wzp](../../wzp)

This script automates the process of starting a new Wezterm project. It allows you to select a project from a predefined list or specify a project name as an argument.

## Usage

Run the script without any arguments to select a project from the list of available projects. Alternatively, you can provide a project name as an argument to start that specific project.

```bash
./wzp [project_name]
```

### Example Usage

1. Select a project from the list:

```bash
./wzp
```

2. Start a specific project:

```bash
./wzp my_project
```

## Script Details

- The script sets the `PROJECTS_DIR` to `~/.config/wezterm/projects`.
- If no argument is provided, the script lists all `.lua` files in the `PROJECTS_DIR` and allows the user to select one using `fzf`.
- If an argument is provided, the script checks if the corresponding `.lua` file exists in the `PROJECTS_DIR`.
- If a project is selected or specified, the script sets the `WZ_PROJECT` environment variable and starts Wezterm with the selected project.

## Notes

- Ensure `fd` and `fzf` are installed on your system (`brew install fd fzf` on macOS).
- The script relies on the presence of `.lua` files in the `PROJECTS_DIR` to list and start projects.

