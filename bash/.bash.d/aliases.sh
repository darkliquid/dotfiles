#!/bin/bash
alias vim=nvim
alias vi=nvim
alias ls=exa
alias open="xdg-open"

function nv() {
  if [ -z "$1" ]; then
    neovide.exe --wsl &
  else
    neovide.exe --wsl "$1" &
  fi
}

function getip() {
  INTF="${1:-eth0}"
  ip -o -4 -json addr list $INTF | jq '.[0].addr_info[0].local'
}
