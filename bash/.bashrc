# vim: set sw=2 ts=2 sts=2 et tw=78 foldlevel=0 foldmethod=marker filetype=sh nospell:

# Inclusion guard {{{
[[ -n "$BASH" && -z "$__BASH_CUSTOM__" ]] && readonly __BASH_CUSTOM__=$(realpath "${BASH_SOURCE}")

[[ "$OSTYPE" != "darwin"* ]] && __BASH_CUSTOM_NEW_VERSION__=$(date -r "$__BASH_CUSTOM__" +%s)
[[ "$OSTYPE" == "darwin"* ]] && __BASH_CUSTOM_NEW_VERSION__=$(stat -f '%m' "$__BASH_CUSTOM__")
[[ -n "$__BASH_CUSTOM_VERSION__" && "$__BASH_CUSTOM_VERSION__" -eq "$__BASH_CUSTOM_NEW_VERSION__" ]] && return

__BASH_CUSTOM_VERSION__="$__BASH_CUSTOM_NEW_VERSION__"
if [[ $DEBUG = true ]]; then
  [[ "$OSTYPE" != "darwin"* ]] && echo "$__BASH_CUSTOM__ sourced, modified at $(date --date=@$__BASH_CUSTOM_NEW_VERSION__)"
  [[ "$OSTYPE" == "darwin"* ]] && echo "$__BASH_CUSTOM__ sourced, modified at $(date -r $__BASH_CUSTOM_NEW_VERSION__)"
fi

[[ "$OSTYPE" == "darwin"* ]] && export __SHLIB__=$(dirname $(dirname $(readlink "$HOME/.bashrc.custom")))/shlib
[[ "$OSTYPE" != "darwin"* ]] && export __SHLIB__=$(dirname $(dirname $(readlink -f "$HOME/.bashrc.custom")))/shlib

source "$__SHLIB__/common.sh"
# }}}

# General {{{

# Expand $VAR when pressing tab for completion
shopt -s direxpand

# append to the history file, don't overwrite it
shopt -s histappend

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
# shopt -s globstar

# autocutsel -selection PRIMARY -fork

# Share history across terminals
function _update_ps1() {
  export PS1="$(powerline-shell.py --colorize-hostname $? 2> /dev/null)"
}
export PROMPT_COMMAND="_update_ps1; history -a; history -c; history -r;"

# }}}

# Completions {{{

function _tmux_sessions() {
  local cur
  COMPREPLY=()
  cur=${COMP_WORDS[COMP_CWORD]}

  COMPREPLY=( $( compgen -W "$( command tmux ls -F \"#{session_name}\" )" -- $cur ) )
}
# Function ta() is defined in common.sh and is sourced before this
complete -F _tmux_sessions -o default ta
# complete -F _tmux_sessions -o default ts
# complete -F _tmux_sessions -o default tk

# }}}

# Additional configurations to load {{{

if [ -f "$HOME/.bashrc.local" ]; then
  source ~/.bashrc.local
fi

# Tmuxinator
if [ -e "$HOME/.tmuxinator.bash" ]; then
  source ~/.tmuxinator.bash
fi

function config_darwin() {
  alias updatedb="sudo /usr/libexec/locate.updatedb"
  alias ls="ls -F -G"
}

function config_linux() {
  alias ls="ls -F --color=auto"
}

[[ "$OSTYPE" == "darwin"* ]] && config_darwin
[[ "$OSTYPE" == "linux-gnu"* ]] && config_linux

# }}}
