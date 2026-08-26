#!/usr/bin/env zsh

# Check if we are in the 'dotfiles' folder
[ ${PWD##*/} = 'dotfiles' ] || exit 1

HOSTNAME="$(hostname -s)"
ARG="$1"

create_links() {

    # find magic
    find -name '*.git*' -prune -o \
        -name 'misc' -prune -o \
        -not -path './.*' \
        -type f -print | while read file; do

        # Remove './' from the beginning
        file="${file#./}"

        # Skip hostname-specific configs
        if [[ "$file" == *-work || "$file" == *-personal ]]; then
            continue
        fi

        if [[ "$file" == bin/* ]]; then
            destination="${file}"
        elif [[ "$file" == config/zsh/* ]]; then
            dirname=$(dirname "$file")
            filename=$(basename "$file")
            destination=".${dirname}/.${filename}"
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

create_missing_folders() {
    mkdir -p "$HOME/.local/state/zsh"
    mkdir -p "$HOME/.cache"
}

# Disable Discord checking for updates
update_discord_settings() {
    DISCORD_CONFIG="$HOME/.config/discord/settings.json"

    command -v jq &>/dev/null || return
    [ -f $DISCORD_CONFIG ] || return
    [ $(<$DISCORD_CONFIG jq 'has("SKIP_HOST_UPDATE")') = 'false' ] || return

    echo "Updating Discord config"
    jq '. += { "SKIP_HOST_UPDATE" : true }' <$DISCORD_CONFIG >/tmp/discord.json
    mv /tmp/discord.json $DISCORD_CONFIG
}

setup_git_user_config() {
    local source
    if [[ "$HOSTNAME" == *"BC"* ]]; then
        source="config/git/config-work"
    else
        source="config/git/config-personal"
    fi

    local target="$HOME/.config/git/config-user"

    # Only (re)link and print if it isn't already pointing at the right file.
    # readlink alone would return the relative symlink target (e.g.
    # "../../dotfiles/..."), so resolve both sides with -f before comparing.
    if [[ "$ARG" == "-f" || "$(readlink -f "$target")" != "$(readlink -f "$source")" ]]; then
        ln -rsfv "$source" "$target"
    fi
}

create_links
update_discord_settings
setup_git_user_config
