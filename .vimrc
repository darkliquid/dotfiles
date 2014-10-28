filetype plugin indent on
syntax on
if $SHELL =~ 'fish'
  set shell=/bin/bash
endif
set number
set nocompatible
set laststatus=2
set statusline=%<%f%m\ \[%{&ff}:%{&fenc}:%Y]\ %{getcwd()}\ %=\ Line:%l\/%L\ Column:%c%V\ %P
