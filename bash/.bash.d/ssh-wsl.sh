#!/bin/bash

WSL2SSH=$HOME/.local/bin/wsl2-ssh-agent
export SSH_AUTH_SOCK=$HOME/.ssh/agent.sock

__get_wsl2ssh () {
  curl -Ls https://github.com/mame/wsl2-ssh-agent/releases/latest/download/wsl2-ssh-agent --output $WSL2SSH
  chmod +x $WSL2SSH
}

setup_wsl2ssh () {
  [[ -f $WSL2SSH ]] || __get_wsl2ssh

  ss -a | grep -q $SSH_AUTH_SOCK
  [[ $? -ne 0 ]] | return

  rm -f $SSH_AUTH_SOCK
  eval $(wsl2-ssh-agent -socket $SSH_AUTH_SOCK)
}

setup_wsl2ssh

