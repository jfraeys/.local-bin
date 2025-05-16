#!/usr/bin/env bash

# Function to add '---' to YAML files if not present
add_yaml_header() {
  while IFS= read -r file; do
    if ! grep -q '^---' "$file"; then
      echo "Adding --- to $file"
      sed -i '1s/^/---\n/' "$file"
    fi
  done < <(fd -t f -e yaml -e yml "$1")
}

# Check if a directory is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <directory>"
  exit 1
fi

# Call the function with the provided directory
add_yaml_header "$1"

