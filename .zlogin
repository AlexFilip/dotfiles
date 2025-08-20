#!/bin/zsh

LOG_FILE=$HOME/zsh-login-error-log
if [[ "$(tty)" == "/dev/tty1" ]]; then
    if [[ $(loginctl list-sessions | grep $(tty) | wc -l) > 1 ]]; then
        echo "Already logged in on tty1. Exiting" > $LOG_FILE
        exit 1
    fi

    exec sway-custom
fi
