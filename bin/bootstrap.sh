#!/bin/bash

directory=$(dirname $(pwd))
echo $directory

# find magic
find . -maxdepth 2 -not -name '*work' -name '.git*' -prune -o -name 'misc' -prune -o -print
