#!/bin/bash

if [ ! -z ${WSL_AUTH_SOCK} ]; then
	export SSH_AUTH_SOCK=${WSL_AUTH_SOCK}
elif [[ -n "$IS_WSL" || -n "$WSL_DISTRO_NAME" ]]; then 
	export SSH_AUTH_SOCK=$HOME/.ssh/agent.sock
	ss -a | grep -q $SSH_AUTH_SOCK
	if [ $? -ne 0   ]; then
		rm -f $SSH_AUTH_SOCK
		( setsid socat UNIX-LISTEN:$SSH_AUTH_SOCK,fork EXEC:"/mnt/c/Users/${USER}/scoop/apps/wsl-ssh-agent/current/npiperelay.exe -ei -s //./pipe/openssh-ssh-agent",nofork & ) >/dev/null 2>&1
	fi
fi
