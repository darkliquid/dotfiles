#!/bin/sh

# exist checks if a command exist in shell
exist() {
    command -v "$1" >/dev/null 2>&1
}

# log writes message to stdout with a timestamp in blue
log() {
    printf "\033[33;34m [%s] %s\n" "$(date)" "$1"
}

log "Running run_once_init.sh once..."

# Install Homebrew
# https://brew.sh/
if exist brew; then
    log "Updating Homebrew..."
    brew update
else
    log "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

log "Done. Please restart your shell."