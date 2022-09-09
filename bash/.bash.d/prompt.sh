#!/bin/bash

eval "$(starship init bash | sed 's%Cellar/.*/bin%bin%')"
