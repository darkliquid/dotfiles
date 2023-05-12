#!/bin/bash

# Based on the article here: https://dev.to/bowmanjd/install-docker-on-windows-wsl-without-docker-desktop-34m9
if [[ -n "$IS_WSL" || -n "$WSL_DISTRO_NAME" ]]; then
	DOCKER_DIR=/mnt/wsl/shared-docker
	DOCKER_SOCK="$DOCKER_DIR/docker.sock"
	test -S "$DOCKER_SOCK" && export DOCKER_HOST="unix://$DOCKER_SOCK"

	function start_docker() {
	  if [ ! -S "$DOCKER_SOCK" ]; then
	    mkdir -pm o=,ug=rwx "$DOCKER_DIR"
	    chgrp docker "$DOCKER_DIR"
	    nohup sudo -b dockerd < /dev/null > $DOCKER_DIR/dockerd.log 2>&1
	  fi
	  export DOCKER_HOST="unix://$DOCKER_SOCK"
	}
fi

function docker_all() {
  docker ps --format '{{.ID}}' | xargs docker $@
}
