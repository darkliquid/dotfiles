set -gx UNAME_S (uname -s)

# Path
set -gx PATH /usr/local/bin $PATH

if [ $UNAME_S = 'Linux' ]
	set -gx PATH $HOME/.linuxbrew/bin $PATH
	set -gx PATH $HOME/.local/bin $PATH
	set -gx MANPATH ":$HOME/.linuxbrew/share/man:$MANPATH"
	set -gx INFOPATH $HOME/.linuxbrew/share/info $INFOPATH
end

# Composer
set -gx PATH $HOME/.composer/vendor/bin $PATH

# Powerline
if [ $UNAME_S = 'Linux' ]
	set POWERLINE_PFX $HOME/.local/lib/python2.7/site-packages
else
	set POWERLINE_PFX (brew --prefix)/lib/python2.7/site-packages
end
set fish_function_path $fish_function_path $POWERLINE_PFX/powerline/bindings/fish
powerline-setup

function fish_greeting
end

function fish_title
	if [ $_ = 'fish' ]
		pwd
	else
		echo $_
	end
end

# Autojump
. (brew --prefix autojump)/etc/autojump.fish

# Virtual Fish
. ~/.config/fish/virtual.fish
. ~/.config/fish/auto_activation.fish

# Django Fish
__fish_complete_django django-admin.py
__fish_complete_django manage.py

# Vars 
set -gx EDITOR "atom --wait"
set -gx HOMEBREW_GITHUB_API_TOKEN #__HOMEBREW_GITHUB_API_TOKEN__

# Golang
set -gx GOROOT (go env GOROOT)
set -gx GOPATH ~/Go
set -gx PATH $GOPATH/bin $PATH
