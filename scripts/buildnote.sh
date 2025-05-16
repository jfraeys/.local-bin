#!/usr/bin/env bash

# Ensure both input and output file arguments are provided
if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <input_file> <output_file>"
  exit 1
fi

input_file="$1"
output_file="$2"

# Ensure the input file exists
if [ ! -f "$input_file" ]; then
  echo "Error: File $input_file does not exist."
  exit 1
fi

# Generate PDF using pandoc with the specified options
pandoc \
  --pdf-engine=xelatex \
  --highlight-style=pygments \
  -V colorlinks -V urlcolor=NavyBlue \
  -V mainfont="DejaVuSerif" \
  -V mainfontoptions="Extension=.ttf, UprightFont=*, BoldFont=*-Bold, ItalicFont=*-Italic, BoldItalicFont=*-BoldItalic" \
  -V sansfont="DejaVuSans" \
  -V monofont="DejaVuSansMono" \
  -V geometry:margin=1in \
  -o "$output_file" "$input_file" &

# Print the output path for use in Neovim
echo "$output_file"
