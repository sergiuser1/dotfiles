#!/usr/bin/env bash

# Check if we are in the 'dotfiles' folder
[ ${PWD##*/} = 'dotfiles' ] || exit 1

HOSTNAME="$(hostname -s)"
ARG="$1"

create_links() {

    # find magic
    find -name '*.git*' -prune -o \
    -name 'misc' -prune -o \
    -type f -print | while read file; do

        # Remove './' from the beginning
        file="${file#./}"

        if [[ "$file" == bin/* ]]; then
            destination="${file}"
        else
            destination=".${file}"
        fi

        # Make sure the folders exist
        mkdir -p "$(dirname "$HOME/$destination")"

        # ln makes backups even the file is a symlink
        if [[ "$ARG" == "-f" || ! -L "$HOME/$destination" ]]; then
            ln -rsfv --backup=simple "$file" "$HOME/$destination"
        fi
    done

    echo "Done"
}

# Create base links
create_links
