#! /bin/bash

# Init Starship
eval "$(starship init zsh)"
# PATHS
export GIT_EDITOR=nvim

# PLUGINS
source ~/.config/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.config/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# CONFIGS

source $HOME/.config/zsh/functions.zsh
source $HOME/.config/zsh/aliases.zsh
