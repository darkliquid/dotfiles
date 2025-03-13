# Load SSH identities if required.
function load_ssh_identities() {
    if [ "$(ssh-add -l)" == "The agent has no identities." ]; then
        ssh-add
    fi
}

# Simple wrapper to run all the updates
function update() {
    load_ssh_identities
    chezmoi update
    if [ $(id -u) -eq 0 ]; then
        aptitude update
        aptitude safe-upgrade
    else
        log "Not running as root, skipping apt..."
    fi
    brew upgrade
    mise upgrade
    code --update-extensions

    # If running under WSL, try and run windows pkg updates too.
    if [[ -n "$WSL_DISTRO_NAME" ]]; then
        scoop upgrade
    fi
}