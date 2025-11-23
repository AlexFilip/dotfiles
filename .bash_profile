#!/bin/bash

source $HOME/.bashrc

# Just in case an update breaks the login shell
if shopt -q login_shell || [[ "$0" == -* ]] || [[ "$TTY" =~ ^/dev/tty[0-9]+$ ]]; then
    source $HOME/.bash_login
fi