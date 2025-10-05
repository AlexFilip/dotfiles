#!/bin/bash

RESET_COLOR="\e[0m"

BLACK="\e[0;30m"
RED="\e[0;31m"
GREEN="\e[0;32m"
YELLOW="\e[0;33m"
BLUE="\e[0;34m"
MAGENTA="\e[0;35m"
CYAN="\e[0;36m"
WHITE="\e[0;37m"

BRIGHT_BLACK="\e[0;38m"
BRIGHT_RED="\e[0;39m"
BRIGHT_GREEN="\e[0;40m"
BRIGHT_YELLOW="\e[0;41m"
BRIGHT_BLUE="\e[0;42m"
BRIGHT_MAGENTA="\e[0;43m"
BRIGHT_CYAN="\e[0;44m"
BRIGHT_WHITE="\e[0;45m"

no-color() {
    sed -E "s/\x1b\\[[0-9;]+[mK]//g"
}

alias ls='ls --color=auto'
alias dotfiles="/usr/bin/git --work-tree=$HOME --git-dir=$HOME/.rc-files"
alias dfcp="dotfiles commit -a && dotfiles pull --rebase && dotfiles push"
alias dfpu="dotfiles pull"

# useful less flag: -S disables line-wrapping
alias less='less -mNgiJQuR'
export LESSHISTFILE="-" # no lesshst
export HISTCONTROL=ignoreboth # Ignore repeated command and commands that begin with a space

PIP_INSTALL_PATH="$(python3 -m site --user-base)/bin"

path_add_begin() {
    for x in $@; do
        if [[ -d "$x" ]] && [[ ":$PATH:" != *":$x:"* ]]; then
            PATH="$x${PATH:+":$PATH"}"
        fi
    done
}

path_add_end() {
    for x in $@; do
        if [[ -d "$x" ]] && [[ ":$PATH:" != *":$x:"* ]]; then
            PATH="${PATH:+"$PATH:"}$x"
        fi
    done
}

path_add_begin \
    /usr/local/bin \
    $HOME/bin/go \
    $HOME/bin

# path_add_end \
#     "/home/alex/.local/share/coursier/bin"

export GPG_TTY=$(tty)
export GOBIN=$HOME/bin/go
export PATH
export SBT_OPTS="-Xmx4G"

# export EDITOR=vim
# export VISUAL=vim
export EDITOR=$HOME/bin/applications/emacs
export VISUAL="$HOME/bin/applications/emacs -nw"
set -o emacs

# --- Prompt ---
PROMPT_COLOR="\[$(tput setaf 3)\]" # Yellow
PROMPT_RESET="\[$(tput sgr0)\]"

-prompt-ssh-info() {
    local RESULT=''

    if [[ -n "$SSH_CONNECTION" ]]; then
        RESULT+="$USER@$(hostname) "
    fi

    echo -n "$RESULT"
}

-prompt-env-info() {
    local RESULT=''
    if $(source ~/bin/pvt/is-git-repo); then
        # is a git repo
        RESULT+="${PROMPT_COLOR}[${PROMPT_RESET}$(git branch --show-current)${PROMPT_COLOR}] "
    fi

    if which kubectl > /dev/null 2>&1; then
        local KUBE_CONTEXT
        KUBE_CONTEXT=$(kubectl config current-context 2>&1)
        if [[ $? == 0 ]]; then
            RESULT+="${PROMPT_COLOR}[${PROMPT_RESET}${KUBE_CONTEXT}${PROMPT_COLOR}] "
        fi
    fi

    echo -n "$RESULT"
}

PROMPT_COMMAND='PS1="$(-prompt-ssh-info)${PROMPT_COLOR}\w $(-prompt-env-info)\n${PROMPT_COLOR}\$ ${PROMPT_RESET}"'
PS2="${PROMPT_COLOR}> ${PROMPT_RESET}"
# --- End Prompt ---

# --- Language specific configs ---
#   Node
export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

#   Rust
[ -d "$HOME/.cargo" ] && . "$HOME/.cargo/env"
# --- End Language specific configs ---
