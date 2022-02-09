#!/bin/bash

function command_not_found_handle() {
    # Don't bother trying all this smart matching when receiving piped input
    if [ -p /dev/stdin ]; then
        printf "%s: command not found\n" "$1" >&2
		return 127
    fi

	cmd=$1
	shift

	# build up a list of commands that are available
	cmds=$(
		# PATH is : delimited
		IFS=:
		for p in $PATH; do
			# WSL mounts are on v9fs, so only search for specific executable extensions
			if [[ $(stat "$p" --file-system --printf=%T 2> /dev/null) == "v9fs" ]]; then
				find "$p" -maxdepth 1 -executable -type f \( -iname "*.exe" -o -iname "*.cmd"  \) 2> /dev/null
			else
				find "$p" -maxdepth 1 -executable -type f 2> /dev/null
			fi
		done
	)

	# fzf search based on the file name (not the full path) using the initial param as the starting search
	run=$(echo "$cmds" | fzf -q "$cmd" -d / -n -1 --preview="echo {-1} $*" --preview-window=down,1)
	if [[ -n "$run" && $? -eq 0 ]]; then
		# run the command
		"$run" $*
	elif [ -x /usr/lib/command-not-found ]; then
		/usr/lib/command-not-found -- "$cmd"
		return $?
	elif [ -x /usr/share/command-not-found/command-not-found ]; then
		/usr/share/command-not-found/command-not-found -- "$cmd"
		return $?
	else
		printf "%s: command not found\n" "$cmd" >&2
		return 127
	fi
}