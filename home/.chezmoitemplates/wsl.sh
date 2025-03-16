# WSL Stuff
if [[ -n "$WSL_DISTRO_NAME" ]]; then
    if [ -e "$HOME/.local/omni-socat/omni-socat.sh" ]; then
        source $HOME/.local/omni-socat/omni-socat.sh
    fi

    # A friendly wrapper around the windows where utility
    function winwhere() {
        local whereexe="$(wslpath 'C:\Windows\System32\where.exe')"
        local exe="$($whereexe $1 2>/dev/null | head -1 | tr -d '\n\r')"
        if [ -z "$exe" ]; then
            return 127
        fi

        local exe="$(wslpath "$exe")"
        echo -n "$exe"
    }

    # Add windows shells to PATH
    cmdexe="$(winwhere cmd)"
    if [ -e "$cmdexe" ]; then
        pathappend "$(dirname $cmdexe)"
    fi
    unset cmdexe

    pwshexe="$(winwhere pwsh)"
    if [ -e "$pwshexe" ]; then
        pathappend "$(dirname $pwshexe)"
    fi
    unset pwshexe

    powershellexe="$(winwhere powershell)"
    if [ -e "$powershellexe" ]; then
        pathappend "$(dirname $powershellexe)"
    fi
    unset powershellexe

    # This is a nicer way of handling windows executables on the path
    # compared to filling the path with a ton of windows paths that cause
    # anything that needs to scan/traverse PATH to be slow to start due to
    # having to go via the slow file system bridge. Instead, we use the command
    # not found handler to instead do a lookup with the windows where.exe utility
    # for an executable to run.
    eval "$(
        echo 'original_command_not_found_handle()'
        declare -f command_not_found_handle | tail -n +2
    )"
    function command_not_found_handle() {
        local cmd=$1
        shift

        # If we find a Windows command, run it
        wslcmd="$(winwhere $cmd)"
        if [ -e "$wslcmd" ]; then
            $wslcmd $*
            return $?
        fi

        # Otherwise default to the original behaviour
        original_command_not_found_handle $cmd $*
    }

    # Upgrade our exist function if defined to handle wsl command lookups too.
    if [[ $(type -t exist) == function ]]; then
        eval "$(
            echo 'original_exist()'
            declare -f exist | tail -n +2
        )"
        function exist() {
            if ! original_exist() ; then
                winwhere "$1"
            fi
        }
    fi
fi
