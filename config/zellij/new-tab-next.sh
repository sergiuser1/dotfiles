#!/bin/sh
pos=$(zellij action list-panes --json </dev/null \
    | jq -r --argjson id "$ZELLIJ_PANE_ID" '.[] | select(.is_plugin | not) | select(.id == $id) | .tab_position')
count=$(zellij action list-tabs --json </dev/null | jq length)
id=$(zellij action new-tab --cwd "$PWD" </dev/null)
[ -z "$pos" ] || [ -z "$id" ] && exit 0
n=$((count - pos - 1))
while [ "$n" -gt 0 ]; do
    zellij action move-tab --tab-id "$id" left </dev/null
    n=$((n - 1))
done
