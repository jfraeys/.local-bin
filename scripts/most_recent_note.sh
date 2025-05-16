#!/usr/bin/env bash

find ~/Google\ Drive/My\ Drive/notes/pdf -name '*.pdf' -print0 | xargs -0 ls -t | head -n 1 | xargs -I {} zathura {}
