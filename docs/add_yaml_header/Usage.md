## [yaml_header_adder](../../yaml_header_adder)

This script automates the process of ensuring that YAML files within a specified directory contain the necessary `---` header. If a YAML file does not have the `---` header, the script adds it.

## Usage

Run the script with the directory containing your YAML files as an argument. The script will check each file in the directory (and its subdirectories) to see if it starts with `---`. If the header is missing, the script will add it.

```bash
./yaml_header_adder.sh <directory>
```

### Example Usage

Automatically add `---` headers to YAML files in the specified directory:

```bash
./yaml_header_adder.sh /path/to/directory
```

## Script Details

- The script uses `fd` to find all files with the `.yaml` or `.yml` extension in the specified directory.
- For each file, it checks if the first line is `---`.
- If the `---` header is missing, it adds it to the top of the file using `sed`.

## Notes

- Ensure `fd` is installed (`brew install fd` on macOS).
- The script modifies files in place; consider using version control to track changes.

