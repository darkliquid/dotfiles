#!/bin/bash

if [[ -n "$IS_WSL" || -n "$WSL_DISTRO_NAME" ]]; then
	DOCKER_SOCK="/mnt/wsl/shared-docker/docker.sock"
	test -S "$DOCKER_SOCK" && export DOCKER_HOST="unix://$DOCKER_SOCK"

	function start_docker() {
	  if [ ! -S "$DOCKER_SOCK" ]; then
	    mkdir -pm o=,ug=rw "$DOCKER_DIR"
	    chgrp docker "$DOCKER_DIR"
	    nohup sudo -b dockerd < /dev/null > $DOCKER_DIR/dockerd.log 2>&1
	  fi
	}
fi
