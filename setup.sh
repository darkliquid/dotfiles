#!/bin/bash

# Get dotfiles installation directory
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

yellow=`tput setaf 3`
reset=`tput sgr0`

function msg() {
	echo  "${yellow}${*}${reset}"
}

# Basic install requirements (check if installed first so we can skip sudo)
msg "Installing essentials..."
pkgs=( socat build-essential curl file git stow xdg-utils libsecret-1-0 libsecret-1-dev libglib2.0-dev wget libfuse2 )
for pkg in "${pkgs[@]}"; do
	dpkg-query --show --showformat='${db:Status-Status}' $pkg &> /dev/null
	if [ $? -ne 0 ]; then
		sudo apt install -y $pkg
	else
		msg "$pkg already installed..."
	fi
done

# Ensure config dir exist
mkdir -p ~/.config

# Install homebrew
if [ ! -d "/home/linuxbrew" ]; then
	msg "Installing homebrew..."
	bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
else
	msg "Skipping homebrew, already installed..."
fi

# Add brew to the path
export PATH=/home/linuxbrew/.linuxbrew/bin:$PATH

# Setup sourcer for bash scripts in profile
grep -qxF '# source bash addons' $HOME/.profile
if [ $? -ne 0 ]; then
	msg "Setting up .profile bash hooks..."
	cat >> $HOME/.profile << 'EOF'

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
if [ ! -f "$HOME/.local/bin/wsl-open" ]; then
	msg "Installing wsl-open..."
	mkdir -p ~/.local/bin
	curl -o ~/.local/bin/wsl-open https://raw.githubusercontent.com/4U6U57/wsl-open/master/wsl-open.sh
	chmod +x ~/.local/bin/wsl-open
fi

# Install libsecret credential manager
if [ ! -f "$HOME/.local/bin/git-credential-libsecret" ]; then
	cp -R /usr/share/doc/git/contrib/credential/libsecret /tmp
	pushd /tmp/libsecret
	make
	mv git-credential-libsecret ~/.local/bin
	popd
	rm -Rf /tmp/libsecret
fi

# Install common brews
msg "Installing common brew formulas..."
read -r -d '' BREWS << EOF
hexyl
noborus/tap/ov
procs
html-xml-utils
tealdeer
rsteube/tap/carapace
mise
EOF
echo "$BREWS" | xargs brew install

# mise tools
mise settings set experimental true
mise use -g fx jq jqp node rust neovim bat eza fzf delta go kubectx ripgrep starship xh zoxide lazygit yarn github-cli
eval "$(mise activate)"

# Symlink other configs
msg "Symlinking in dotfiles..."
shopt -s nullglob
for s in $DOTFILES_DIR/*; do
	if [[ -d $s ]]; then
		s=$(basename $s)
		stow -d $DOTFILES_DIR -t $HOME $s
	fi
done

# neovim install plugins, etc
nvim --headless -c 'Lazy! sync' -c 'qall'

msg "All done!"
