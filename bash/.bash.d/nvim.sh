#!/bin/bash

export PATH=$HOME/.local/share/bob/nvim-bin:$PATH

alias vim=nvim
alias vi=nvim

function nvide() {
	if [ -z "$1" ]; then
		neovide.exe --wsl --multigrid &
	else
		neovide.exe --wsl --multigrid "$1" &
	fi
}
