#!/bin/bash

BLESH_SRC=~/.local/share/blesh/ble.sh

if [ ! -f "$BLESH_SRC" ]; then
  curl -sL https://api.github.com/repos/akinomyoga/ble.sh/releases/latest | jq -r '.assets[0].browser_download_url' | xargs curl -qL | tar xJf - -C ~/.local/share/blesh --strip-components=1
  chmod +x $BLESH_SRC
fi

source $BLESH_SRC
