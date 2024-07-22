# `fzf_theme` Script Usage

## **Overview**

The `fzf_themen` script configures the `fzf` color theme based on the system's appearance mode (Light or Dark). It is compatible with macOS and Linux systems, adjusting the `fzf` theme colors to ensure optimal visibility and aesthetics.

## **Usage**

### **Basic Usage**

To automatically detect the system's appearance mode and apply the corresponding `fzf` theme, run:

```bash
./fzf_themen.sh
```

### **Custom Appearance Mode**

To override the automatic detection and set a specific appearance mode, provide either `Light` or `Dark` as an argument:

```bash
./fzf_themen.sh Light
```

or

```bash
./fzf_themen.sh Dark
```

### **Example**

To use the script's output for configuring `fzf`, you can capture the `FZF_DEFAULT_OPTS` and use it as follows:

```bash
export FZF_DEFAULT_OPTS="$(./fzf_themen.sh)"
fzf --preview "echo 'Preview content'"
```

## **System Compatibility**

- **macOS**: Detects system appearance using the `defaults` command.
- **Linux (GNOME)**: Detects appearance using the `gsettings` command.

If the system is not recognized or detection fails, the script defaults to Dark mode.

## **Dependencies**

- `fzf`: Ensure `fzf` is installed and configured in your environment to utilize the output of this script.

## **Notes**

- For persistent use, consider adding the script to your shell initialization file to automatically set the `fzf` theme in new terminal sessions.

