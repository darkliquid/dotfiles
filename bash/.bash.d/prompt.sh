#!/bin/bash

if [ -f "$HOME/.cargo/bin/powerline-rs" ]; then
	prompt() {
		PS1="$(powerline-rs --shell bash $?)"
	}

	PROMPT_COMMAND=prompt
fi