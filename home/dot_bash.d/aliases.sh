# Starts calculator with math support.
alias bc='bc -l'

# Makes file commands verbose.
alias cp='cp -v';
alias mv='mv -v';

# Displays drives and space in human readable format.
alias df='df -h'

# Prints disk usage per directory non-recursively, in human readable format.
alias du='du -h -d1'

# Colorizes the `grep` output.
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# Uses human sizes, classifications, and color output for `ls`.
alias ls='eza'

# Creates parent directories on demand.
alias mkdir='mkdir -pv'

# List mounts nicely
alias lsmnt='mount | column -t'

# Enables simple aliases to be sudo'ed.
# See http://www.gnu.org/software/bash/manual/bashref.html#Aliases
alias sudo='sudo ';

# Easier navigation
alias cd-='cd -'
alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../../../'
alias ....='cd ../../../../'
alias .....='cd ../../../../'
alias .4='cd ../../../../'
alias .5='cd ../../../../..'

# Lists visible files in long format.
alias l='eza -l'

# Lists all files in long format, excluding `.` and `..`.
alias ll='eza -lA'

# Lists directories only, in long format.
alias lsd='eza -lD'

# Lists hidden files in long format.
alias lsh='eza -dlA .?*'

# Finds directories.
alias fd='find . -type d -name'

# Finds files.
alias ff='find . -type f -name'

# Clears the console screen.
alias c='clear'

# Reloads the configuration.
alias reloadsh='. $HOME/.bash_profile'

# Gets local/UTC date and time in ISO-8601 format `YYYY-MM-DDThh:mm:ss`.
alias now='date +"%Y-%m-%dT%H:%M:%S"'
alias unow='date -u +"%Y-%m-%dT%H:%M:%S"'

# Gets date in `YYYY-MM-DD` format`
alias nowdate='date +"%Y-%m-%d"'
alias unowdate='date -u +"%Y-%m-%d"'

# Gets time in `hh:mm:ss` format`
alias nowtime='date +"%T"'
alias unowtime='date -u +"%T"'

# Gets Unix time stamp`
alias timestamp='date -u +%s'

# Gets week number in ISO-8601 format `YYYY-Www`.
alias week='date +"%Y-W%V"'

# Gets weekday number.
alias weekday='date +"%u"'

# Gets all IP addresses.
alias ips="ip address | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"

# Gets local IP address.
alias localip="ip route get 1 | head -1 | sed -re 's/.*src ([0-9a-fA-F:.]+) .*/\1/'"

# Gets external IP address.
if command -v dig &> /dev/null; then
    alias publicip='dig +short myip.opendns.com @resolver1.opendns.com'
elif command -v curl > /dev/null; then
    alias publicip='curl --silent --compressed --max-time 5 --url "https://ipinfo.io/ip"'
else
    alias publicip='wget -qO- --compression=auto --timeout=5 "https://ipinfo.io/ip"'
fi

# Prints each $PATH entry on a separate line.
alias path='echo -e ${PATH//:/\\n}'