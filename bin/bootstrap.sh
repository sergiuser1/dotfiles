#!/bin/bash

directory=$(dirname $(pwd))
echo $directory

echo ${BASH_SOURCE[0]}
relpath() {
    # both $1 and $2 are absolute paths beginning with /
    # $1 must be a canonical path; that is none of its directory
    # components may be ".", ".." or a symbolic link
    #
    # returns relative path to $2/$target from $1/$source
    source=$1
    target=$2

    common_part=$source
    result=

    while [ "${target#"$common_part"}" = "$target" ]; do
        # no match, means that candidate common part is not correct
        # go up one level (reduce common part)
        common_part=$(dirname "$common_part")
        # and record that we went back, with correct / handling
        if [ -z "$result" ]; then
            result=..
        else
            result=../$result
        fi
    done

    if [ "$common_part" = / ]; then
        # special case for root (no common path)
        result=$result/
    fi

    # since we now have identified the common part,
    # compute the non-common part
    forward_part=${target#"$common_part"}

    # and now stick all parts together
    if [ -n "$result" ] && [ -n "$forward_part" ]; then
        result=$result$forward_part
    elif [ -n "$forward_part" ]; then
        # extra slash removal
        result=${forward_part#?}
    fi

    printf '%s\n' "$result"
}
relpath "$directory" "$HOME"
