# Powerline
set fish_function_path $fish_function_path (brew --prefix)/lib/python2.7/site-packages/powerline/bindings/fish
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

# Path
set -gx PATH /usr/local/bin $PATH

# Vars 
set -gx EDITOR subl -w
set -gx GOROOT (go env GOROOT)
set -gx GOPATH ~/Go
set -gx HOMEBREW_GITHUB_API_TOKEN #__HOMEBREW_GITHUB_API_TOKEN__
