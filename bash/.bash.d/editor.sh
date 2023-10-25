#!/bin/bash

export EDITOR=nvim

update_nvim ()
{
  gum spin --title="Updating nvim..." -- bob update --all
  gum spin --title="Updating nvim plugins..." -- nvim --headless "+Lazy! update" +qa
}
