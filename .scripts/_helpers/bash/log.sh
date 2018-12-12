#!/bin/bash


# fun: log_warn
# txt: log success status message to the terminal
# opt: message<string>
# use: log_warn "Hello World"
log_warn() {
    echo -e "\033[00;33m$1\033[1m\033[0m"
}


# fun: log_success
# txt: log success status message to the terminal
# opt: message<string>
# use: log_success "Hello World"
log_success() {
    echo -e "\033[00;32m$1\033[1m\033[0m"
}


# fun: log_error
# txt: log error status message to the terminal
# opt: message<string>
# use: log_error "Hello World"
log_error() {
    echo -e "\033[00;31m$1\033[1m\033[0m"
}
