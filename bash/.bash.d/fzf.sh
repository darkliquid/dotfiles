#!/bin/bash

# Useful fzf functions
function fzfrg() {
	# Two-phase filtering with Ripgrep and fzf
	#
	# 1. Search for text in files using Ripgrep
	# 2. Interactively restart Ripgrep with reload action
	#    * Press ctrl-f to switch to fzf-only filtering
	# 3. Open the file in $EDITOR
	RG_PREFIX="rg --column --line-number --no-heading --color=always --smart-case "
	INITIAL_QUERY="${*:-}"
	IFS=: read -ra selected < <(
	  FZF_DEFAULT_COMMAND="$RG_PREFIX $(printf %q "$INITIAL_QUERY")" \
	  fzf --ansi \
	      --color "hl:-1:underline,hl+:-1:underline:reverse" \
	      --disabled --query "$INITIAL_QUERY" \
	      --bind "change:reload:sleep 0.1; $RG_PREFIX {q} || true" \
	      --bind "ctrl-f:unbind(change,ctrl-f)+change-prompt(2. fzf> )+enable-search+clear-query" \
	      --prompt '1. ripgrep> ' \
	      --delimiter : \
	      --preview 'bat --color=always {1} --highlight-line {2}' \
	      --preview-window 'up,60%,border-bottom,+{2}+3/3,~3'
	)
	[ -n "${selected[0]}" ] && $EDITOR "${selected[0]}" "+${selected[1]}"
}

export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS' --color=fg:#7d8590,bg:#30363d,hl:#ffffff --color=fg+:#e6edf3,bg+:#313f50,hl+:#ffa657 --color=info:#d29922,prompt:#2f81f7,pointer:#a371f7 --color=marker:#3fb950,spinner:#6e7681,header:#495058'
