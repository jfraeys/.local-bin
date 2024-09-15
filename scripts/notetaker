#!/usr/bin/env bash

# Define the path for the note file
note_file="$HOME/Google Drive/My Drive/notes/src/note-$(date +%Y-%m-%d).md"

# Check if the note file exists; if not, create it with the YAML front matter and date header
if [ ! -f "$note_file" ]; then
  cat <<EOT >"$note_file"
---
title: "Notes"
author: "Jeremie Fraeys"
date: $(date +%Y-%m-%d)
---
EOT
fi

# Open Neovim, go to the end, add a subtitle with the current time, and start insert mode
nvim -c "norm Go" \
  -c "norm o## $(date +%H:%M)" \
  -c "normal! G2o" \
  -c "normal! zz" \
  -c "startinsert" "$note_file"
