#!/bin/bash

if [ -x "$(command -v thefuck)" ]; then
  eval $(thefuck --alias ffs)

  # Thefuck is incredibly slow on WSL if we let it traverse into Windows
  # so we set this config option to prevent it.
  if [[ -n "$IS_WSL" || -n "$WSL_DISTRO_NAME" ]]; then
    mkdir -p ~/.config/thefuck
    if ! grep -q "^excluded_search_path_prefixes" ~/.config/thefuck/settings.py; then
      echo "excluded_search_path_prefixes = ['/mnt/']" >> ~/.config/thefuck/settings.py
    fi
  fi
fi
