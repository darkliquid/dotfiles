#!/bin/bash

if [ -x "$(command -v thefuck)" ]; then
  eval $(thefuck --alias ffs --enable-experimental-instant-mode)
fi
