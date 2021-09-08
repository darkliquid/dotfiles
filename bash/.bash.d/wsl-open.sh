#!/bin/bash

# Adding wsl-open as a browser for Bash for Windows
if [[ -n "$IS_WSL" || -n "$WSL_DISTRO_NAME" ]]; then
	if [[ -z $BROWSER ]]; then
		export BROWSER=wsl-open
	else
		export BROWSER=$BROWSER:wsl-open
	fi
fi
