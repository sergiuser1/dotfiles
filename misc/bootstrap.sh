#!/bin/bash

# Check if we are in the 'dotfiles' folder
[ ${PWD##*/} = 'dotfiles' ] || exit 1

# find magic
find  -name '*git*' -prune -o -name 'misc' -prune -o -not -name '*.work' \
    -type f -print | while read file; do

    # Remove './' from the beginning
    file="${file#./}"
    # Make sure the folders exist
    mkdir -p "$(dirname "$HOME/$file")"
    ln -rsfv --backup=existing "$file" "$HOME/$file"

done
