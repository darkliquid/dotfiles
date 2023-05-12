#!/bin/bash

# we use print-full-init because we're never going to use bash older than 4.1
eval "$(starship init bash --print-full-init | sed 's%Cellar/.*/bin%bin%')"
