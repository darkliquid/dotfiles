#!/bin/bash
if [ -x "$(command -v pkgx)" ]; then
	eval "$(pkgx --shellcode)"
fi
