#!/bin/bash

# Get dotfiles installation directory
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Basic install requirements
echo "Installing essentials..."
sudo apt install -y build-essential curl file git-core stow

# Install homebrew
if [ ! -d "/home/linuxbrew" ]; then
	echo "Installing homebrew..."
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
else
	echo "Skipping homebrew, already installed..."
fi

# Setup sourcer for bash scripts in profile
grep -qxF '# source bash addons' $HOME/.profile
if [ $? -ne 0 ]; then
	echo "Setting up .profile bash hooks..."
	cat >> $HOME/.profile <<EOF

# source bash addons
if [ -d "$HOME/.bash.d" ]; then
	for file in $HOME/.bash.d/*.sh; do
		source $file
	done
fi

EOF
else
	echo "Skipping .profile bash hooks, already setup..."
fi

# Install common brews
echo "Installing common brews..."
brew install go rust exa fzf neovim

# Install powerline-rs
if [ ! -f "$HOME/.cargo/bin/powerline-rs" ]; then
	echo "Installing powerline-rs..."
	cargo install -q powerline-rs
else
	echo "Skipping install of powerline-rs, already installed..."
fi

# Symlink other configs
echo "Symlinking in dotfiles..."
shopt -s nullglob
for s in $DOTFILES_DIR/*; do
	if [[ -d $s ]]; then
		s=$(basename $s)
		stow -d $DOTFILES_DIR -t $HOME $s
	fi
done

echo "All done!"
