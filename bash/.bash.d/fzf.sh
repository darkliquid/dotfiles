#!/bin/bash
# Setup fzf
# ---------
if [[ ! "$PATH" == */home/linuxbrew/.linuxbrew/opt/fzf/bin* ]]; then
  export PATH="$PATH:/home/linuxbrew/.linuxbrew/opt/fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/linuxbrew/.linuxbrew/opt/fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "/home/linuxbrew/.linuxbrew/opt/fzf/shell/key-bindings.bash"

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
