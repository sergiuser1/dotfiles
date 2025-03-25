## zsh config


# Autocomplete
autoload -Uz compinit
compinit
## Make Ctrl-W delete small words instead of WORDs
autoload -U select-word-style
select-word-style bash

# Case insensitive path-completion
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*'

# Partial completion suggestions
zstyle ':completion:*' list-suffixes
zstyle ':completion:*' expand prefix suffix

# Allow reverse search
stty -ixon

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dir_colors && eval "$(dircolors -b ~/.dir_colors)" || eval "$(dircolors -b)"
fi

precmd() { print -Pn "\e]0;%n@%m:%~\a" }

bold="%B"
green="%F{10}"
blue="%F{4}"
magenta="%F{5}"
white="%F{7}"
reset="%f%b"
PS1="${bold}${green}%n@%m${reset}:${blue}%1~${white}\$${reset} "

# some more ls aliases
alias ls='ls -lFhX --group-directories-first --color=auto'
alias la='ls -A'
alias l='ls -CF'
export LESS='-i -n -R -F -X'
alias grep='grep --color=auto'
alias diff='diff --color=auto'

export EDITOR=nvim
export BROWSER=firefox
export PATH="$HOME/bin:$PATH"
# rerun last command as sudo
alias pls='sudo $(fc -ln -1)'

# alias for sudo vim
alias svim='sudo -e '

# list only hidden files
alias lh='ls -d .?*'

# alias for dotfiles repo
alias dots='git --git-dir=$HOME/dotfiles/.git/ --work-tree=$HOME/dotfiles'

alias clip='xclip -sel clip'
alias iclip='xclip -sel clip -t image/png -o'
alias fig='find | grep '
# Better git blame
# https://blog.andrewray.me/a-better-git-blame/
alias git-follow='git log -p -M --follow --stat --'
alias git-remove-merged-branches='git branch --merged | grep -E -v "(^\*|master|dev)" | xargs git branch -D'

## Enable vi mode
bindkey -v

# Allow backspace and delete to work as expected in vi mode
bindkey "^?" backward-delete-char
bindkey "^W" backward-kill-word
bindkey "^H" backward-delete-char
bindkey "^U" backward-kill-line

# Fix delete key behavior
bindkey "^[[3~" delete-char Vi mode

bindkey '^R' history-incremental-search-backward

bindkey -M viins '\e.' insert-last-word
bindkey -M vicmd '\e.' insert-last-word

# History
HISTCONTROL=ignoreboth
SAVEHIST=10000
HISTSIZE=10000
HISTFILESIZE=20000
HISTFILE=~/.zsh_history

setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_DUPS

color()(set -o pipefail;"$@" 2> >(sed $'s,.*,\e[31m&\e[m,'>&2))

alias xt="export TERM=xterm-256color"
alias belp='bat -l help'

eval "$(zoxide init zsh --cmd j)"
export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --exclude .git'
function urldecode() { : "${*//+/ }"; echo -e "${_//%/\\x}"; }
export RIPGREP_CONFIG_PATH=~/.config/ripgrep/ripgrep.sh
export PSQLRC=~/.config/postgres/psqlrc

# Load Angular CLI autocompletion.
# source <(ng completion script)

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH=$BUN_INSTALL/bin:$PATH

export MANPAGER="less -R --use-color -Dd+g -Du+r"
export MANROFFOPT="-P -c"
