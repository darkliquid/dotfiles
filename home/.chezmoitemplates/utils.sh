
# exist checks if a command exist in shell
exist() {
    command -v "$1" >/dev/null 2>&1
}

# log writes message to stdout with a timestamp in blue
log() {
    printf "\033[33;34m[%s] %s\033[0m\n" "$(date)" "$1"
}

# Append entry to PATH without duplicating existing entries
pathappend() {
  for ARG in "$@"
  do
    if [ -d "$ARG" ] && [[ ":$PATH:" != *":$ARG:"* ]]; then
        PATH="${PATH:+"$PATH:"}$ARG"
    fi
  done
}

# Prepend entry to PATH without duplicating existing entries
pathprepend() {
  for ((i=$#; i>0; i--)); 
  do
    ARG=${!i}
    if [ -d "$ARG" ] && [[ ":$PATH:" != *":$ARG:"* ]]; then
        PATH="$ARG${PATH:+":$PATH"}"
    fi
  done
}
