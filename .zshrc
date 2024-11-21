#!/bin/zsh

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

PROMPT_COLOR="%{$YELLOW%}"

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

tm() {
    if ! [[ $TMUX ]] && [[ $TERM == 'xterm-256color' ]]; then
        local tmux_path=$(which tmux)

        if [[ $tmux_path == "tmux not found" ]]; then
            tmux_path="/usr/local/bin/tmux"
        fi

        ${tmux_path} new -A
    fi
}

no-color() {
    sed -E "s/\x1b\\[[0-9;]+[mK]//g"
}

-prompt-extra-options() {
    local RESULT=''
    if $(~/bin/pvt/is-git-repo); then
        # is a git repo
        RESULT="${RESULT} [${RESET_COLOR}$(git branch --show-current)${PROMPT_COLOR}]"
    fi

    if which kubectl > /dev/null 2>&1; then
        local KUBE_CONTEXT
        KUBE_CONTEXT=$(kubectl config current-context 2>&1)
        if [[ $? == 0 ]]; then
            RESULT="${RESULT} [${RESET_COLOR}${KUBE_CONTEXT}${PROMPT_COLOR}]"
        fi
    fi

    echo $RESULT
}

setopt PROMPT_SUBST
setopt hist_ignore_all_dups

PS1=$'%{\e[0;33m%}%(5~|%-1~/.../%3~|%4~)$(-prompt-extra-options)\n\$ %{\e[0m%}'
PS2=$'%{\e[0;33m%}> %{\e[0m%}'

PIP_INSTALL_PATH="$(python3 -m site --user-base)/bin"

path_add_begin \
    /usr/local/bin \
    $HOME/bin/go \
    $HOME/bin

export GPG_TTY=$(tty)
export GOBIN=$HOME/bin/go
export PATH
export SBT_OPTS="-Xmx4G"

export EDITOR=nvim
export VISUAL=nvim
export VISUAL EDITOR=nvim

# Use modern completion system (Needed for kubectl)
autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# vim bindings for the command line
bindkey -v

zle-keymap-select() {
    if [[ ${KEYMAP} == vicmd ]] || [[ $1 = 'block' ]]; then
        echo -ne ${beam_cursor}
    elif [[ ${KEYMAP} == main ]] || [[ ${KEYMAP} == viins ]] ||
         [[ ${KEYMAP} = '' ]]    || [[ $1 = 'beam' ]]; then
        echo -ne ${block_cursor}
    fi
}
zle -N zle-keymap-select

# After a command remain in the same mode
accept-line() {
    prev_mode=${KEYMAP}
    zle .accept-line
}
zle -N accept-line

zle-line-init() {
    zle -K ${prev_mode:-viins}
}
zle -N zle-line-init

# Start with correct cursor
zle-keymap-select

# Press v in vicmd mode to create a short
# script that will be run in the shell
autoload edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line

alias dotfiles="/usr/bin/git --work-tree=$HOME --git-dir=$HOME/.rc-files"

# useful less flag: -S disables line-wrapping
alias less='less -mNgiJQuR'
export LESSHISTFILE="-" # no lesshst

alias k='kubectl'

export KEYTIMEOUT=1

export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad

if [[ -a ~/.local/zshrc ]]; then
  source ~/.local/zshrc
fi

# Change cursor shape for different vi modes.
# define in ~/.local/zshrc
if [[ -z "$beam_cursor" ]]; then
    beam_cursor='\e[2 q'
fi

if [[ -z "$block_cursor" ]]; then
    block_cursor='\e[6 q'
fi

