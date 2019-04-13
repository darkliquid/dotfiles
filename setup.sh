#!/bin/bash

# Get dotfiles installation directory
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

function msg() {
	echo  "\e[43m$1\e[0m"
}

# Basic install requirements (check if installed first so we can skip sudo)
msg "Installing essentials..."
pkgs=( build-essential curl file git stow xdg-utils )
for pkg in "${pkgs[@]}"; do
	dpkg-query --show --showformat='${db:Status-Status}' $pkg &> /dev/null
	if [ $? -ne 0 ]; then
		sudo apt install -y $pkg
	else
		msg "$pkg already installed..."
	fi
done

# Install homebrew
if [ ! -d "/home/linuxbrew" ]; then
	msg "Installing homebrew..."
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
else
	msg "Skipping homebrew, already installed..."
fi

# Add brew to the path
export PATH=/home/linuxbrew/.linuxbrew/bin:$PATH

# Setup sourcer for bash scripts in profile
grep -qxF '# source bash addons' $HOME/.profile
if [ $? -ne 0 ]; then
	msg "Setting up .profile bash hooks..."
	cat >> $HOME/.profile <<EOF

# source bash addons
if [ -d "$HOME/.bash.d" ]; then
	for file in $HOME/.bash.d/*.sh; do
		source $file
	done
fi

EOF
else
	msg "Skipping .profile bash hooks, already setup..."
fi

# Install wsl-open
msg "Installing wsl-open..."
mkdir -p ~/.local/bin
curl -o ~/.local/bin/wsl-open https://raw.githubusercontent.com/4U6U57/wsl-open/master/wsl-open.sh
chmod +x ~/.local/bin/wsl-open

# Install common brews
msg "Installing common brew formulas..."
brew install go rust exa fzf neovim

# Install powerline-rs
if [ ! -f "$HOME/.cargo/bin/powerline-rs" ]; then
	msg "Installing powerline-rs..."
	cargo install -q powerline-rs
else
	msg "Skipping install of powerline-rs, already installed..."
fi

# Symlink other configs
msg "Symlinking in dotfiles..."
shopt -s nullglob
for s in $DOTFILES_DIR/*; do
	if [[ -d $s ]]; then
		s=$(basename $s)
		stow -d $DOTFILES_DIR -t $HOME $s
	fi
done

msg "All done!"
