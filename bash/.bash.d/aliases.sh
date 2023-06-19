#!/bin/bash
alias ls=exa
alias open="xdg-open"

function getip() {
	INTF="${1:-eth0}"
	ip -o -4 -json addr list $INTF | jq '.[0].addr_info[0].local'
}

function cssselect() {
	# normalize html, select element with css selector, remove extra whitespace
	hxnormalize -x | hxselect -c -s '\0' "$1" | awk 'BEGIN { RS= "\0" } ; { gsub(/[[:space:]]+/," "); sub(/^[[:sp
ace:]]+/,""); sub(/[[:space:]]+$/,"") };1'
}
