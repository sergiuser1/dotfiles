# ~/.bashrc: executed by bash(1) for non-login shells.

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend
case ${TERM} in

  xterm*|rxvt*|Eterm|alacritty|aterm|kterm|gnome*)
     PROMPT_COMMAND=${PROMPT_COMMAND:+$PROMPT_COMMAND; }'printf "\033]0;%s@%s:%s\007" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/\~}"'

    ;;
  screen*)
    PROMPT_COMMAND=${PROMPT_COMMAND:+$PROMPT_COMMAND; }'printf "\033_%s@%s:%s\033\\" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/\~}"'
    ;;
esac
PROMPT_COMMAND="history -a;$PROMPT_COMMAND"

# Allow reverse search
stty -ixon
# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
# shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set a fancy prompt (non-color, unless we know we "want" color)
# case "$TERM" in
#     xterm-color|*-256color) color_prompt=yes;;
# esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dir_colors && eval "$(dircolors -b ~/.dir_colors)" || eval "$(dircolors -b)"
fi

# Defining PS1
bold="\001$(tput bold)\002"
green="\001$(tput setaf 10)\002"
blue="\001$(tput setaf 4)\002"
magenta="\001$(tput setaf 5)\002"
white="\001$(tput setaf 7)\002"
reset="\001$(tput sgr0)\002"
PS1="$bold$green\u@\h$reset:$blue\W$white\$$reset "
# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ls='ls -lFhX --group-directories-first --color=auto'
alias la='ls -A'
alias l='ls -CF'
export LESS='-i -n -R -F -X'
alias grep='grep --color=auto'
alias diff='diff --color=auto'
# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

# if [ -f ~/.bash_aliases ]; then
#     . ~/.bash_aliases
# fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

export EDITOR=nvim
export BROWSER=firefox
export PATH="$HOME/bin:$PATH"
# rerun last command as sudo
alias pls='sudo $(history -p !!)'

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

# Vi mode
set -o vi
bind -m vi-command ".":insert-last-argument
bind -m vi-insert "\C-l.":clear-screen
bind -m vi-insert "\C-a.":beginning-of-line
bind -m vi-insert "\C-e.":end-of-line
bind -m vi-insert "\C-w.":backward-kill-word

color()(set -o pipefail;"$@" 2> >(sed $'s,.*,\e[31m&\e[m,'>&2))
bind 'set match-hidden-files off'
alias xt="export TERM=xterm-256color"
alias belp='bat -l help'
eval "$(zoxide init bash --cmd j)"
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
