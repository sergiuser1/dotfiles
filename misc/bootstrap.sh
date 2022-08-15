#!/usr/bin/env bash

# Check if we are in the 'dotfiles' folder
[ ${PWD##*/} = 'dotfiles' ] || exit 1

HOSTNAME="$(hostname -s)"

create_links() {

    # find magic
    find -name '*git*' -prune -o \
    -name 'misc' -prune -o \
    -name 'desks' -prune -o \
    -name 'sinkpad' -prune -o \
    -type f -print | while read file; do

        # Remove './' from the beginning
        file="${file#./}"
        # Make sure the folders exist
        mkdir -p "$(dirname "$HOME/$file")"

        # ln makes backups even the file is a symlink
        if [[ ! -L "$HOME/$file" ]]; then
            ln -rsfv --backup=simple "$file" "$HOME/$file"
        fi
    done
}

# Create base links
create_links

# Create host specific links
if [ $HOSTNAME == "desks" ]; then
    cd desks/
    create_links
elif [ $HOSTNAME == "sinkpad" ] || [ $HOSTNAME == "delltron" ]; then
    cd sinkpad/
    create_links
fi
