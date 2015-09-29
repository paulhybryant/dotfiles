# vim: filetype=zsh sw=2 ts=2 sts=2 et tw=80 foldlevel=0 nospell

: <<=cut
=pod

=head1 NAME

File: util.zsh - Various utility functions.

=head1 DESCRIPTION

=head2 Methods

=over 4
=cut

init::sourced "${0:a}" && return

: <<=cut
=item Function C<util::_geoinfo>

Get the geo location information.

@return list of values for requested fields.
=cut
function util::_geoinfo() {
  # ip, hostname, city, region, country, loc, org
  local _filter
  _filter=$(strings::join --prefix=. --delim=, "$@")
  echo $(curl -x '' ipinfo.io 2> /dev/null | jq "${_filter}")
}

: <<=cut
=item Function C<util::_start_ssh_agent>

Start ssh agent if not yet.

@return NULL
=cut
function util::_start_ssh_agent() {
  local _agent
  _agent=$1
  # Start ssh agent if needed
  # Check to see if SSH Agent is already running
  # agent_pid="$(ps -ef | grep "${_agent}" | grep -v "grep" | awk '{print($2)}')"
  agent_pid=$(pgrep "${_agent}")

  # If the agent is not running (pid is zero length string)
  if [[ -z "${agent_pid}" ]]; then
      # Start up SSH Agent
      # this seems to be the proper method as opposed to `exec ssh-agent bash`
      eval "$(${_agent})"
  fi
}

: <<=cut
=item Function C<util::_installed_gnome_shell_exts>

List installed gnome shell extensions

@return NULL
=cut
function util::_installed_gnome_shell_exts() {
  grep "name\":" ~/.local/share/gnome-shell/extensions/*/metadata.json /usr/share/gnome-shell/extensions/*/metadata.json | awk -F '"name": "|",' '{print $2}'
}

: <<=cut
=item Function C<util::_ta>

Tmux attach wrapper, which updates tmux environment as configured.

@return NULL
=cut
function util::_ta() {
  for var in ${__tmux_vars__};
  do
    local _value=
    eval _value=\$${var}
    \tmux set-environment ${var} "${_value}"
  done
  tmux attach -t "$1"
}

: <<=cut
=item Function C<util::_histgrep>

Grep in reverse order in history.

@return NULL
=cut
function util::_histgrep() {
  ${CMDPREFIX}tac ${HISTFILE:-~/.zsh_history} | grep -m 1 "$@"
}

: <<=cut
=item Function C<util::eval>

Eval the strings, and output logs based on verbose level.

@return NULL
=cut
function util::eval() {
  setopt localoptions err_return nounset
  if mode::dryrun; then
    io::msg "$*"
  else
    eval $*
  fi
}

: <<=cut
=item Function C<util::_setup_abbrev>

Setup zsh abbreviations.

@return NULL
=cut
function util::_setup_abbrev() {
  # source: http://hackerific.net/2009/01/23/zsh-abbreviations/
  # another impl: https://github.com/smly/config/blob/master/.zsh/abbreviations.zsh
  typeset -Ag abbrevs
  abbrevs=('...' '../..'
          '....' '../../..'
          'cx' 'chmod +x'
          'da' 'du -sch'
          'e'  'print -l'
          'j' 'jobs -l'
          'lad' $'ls -d .*(/)\n# only show dot-directories'
          'lb' 'listabbrevs'
          'lsa' $'ls -a .*(.)\n# only show dot-files'
          'lsbig' $'ls -flh *(.OL[1,10])\n# display the biggest files'
          'lsd' $'ls -d *(/)\n# only show directories'
          'lse' $'ls -d *(/^F)\n# only show empty directories'
          'lsl' $'ls -l *(@[1,10])\n# only symlinks'
          'lsnew' $'ls -rl *(D.om[1,10])\n# display the newest files'
          'lsold' $'ls -rtlh *(D.om[-11,-1])\n# display the oldest files'
          'lss' $'ls -l *(s,S,t)\n# only files with setgid/setuid/sticky flag'
          'lssmall' $'ls -Srl *(.oL[1,10])\n# display the smallest files'
          'lsw' $'ls -ld *(R,W,X.^ND/)\n# world-{readable,writable,executable} files'
          'lsx' $'ls -l *(*[1,10])\n# only executables'
          'md' 'mkdir -p '
  )

  # Create global aliases from the abbreviations.
  for abbr in ${(k)abbrevs}; do
    alias -g $abbr="${abbrevs[$abbr]}"
  done

  function globalias() {
    local MATCH
    LBUFFER=${LBUFFER%%(#m)[_a-zA-Z0-9]#}
    LBUFFER+=${abbrevs[$MATCH]:-$MATCH}
    zle self-insert
  }
  zle -N globalias
  # List abbreviations and abbr binding, picks out help in green.
  function listabbrevs() {
    echo "Displaying shell abbreviations"
    for abbr in ${(ok)abbrevs}; do
      printf "%-20s: %s" $abbr ${abbrevs[$abbr]:s/
  /$fg[green] /} # Replaces newlines with spaces
      print -l $reset_color
    done
  }

  bindkey "  " globalias
  bindkey " " magic-space
}

: <<=cut
=item Function C<util::_brew_upgrade>

Upgrade outdated brew packages.

@return NULL
=cut
function util::_brew_upgrade() {
  brew update
  brew upgrade $(brew outdated)
  # Update pip
}

: <<=cut
=item Function C<util::_vim>

Open files with vim in a single vim instance in one tmux window.

@return NULL
=cut
function util::_vim() {
  local -a _servers_list
  local _server_name
  local _vimflags
  # if [[ ! -z "$SSH_OS" ]]; then
    # _vimflags='-X'
  # fi
  if [[ -z "$TMUX" ]]; then
    io::vlog 1 "Not in tmux, invoking vim without server name."
    \vim ${_vimflags} "$@"
  else
    _servers_list=($(\vim --serverlist))
    io::vlog 1 "Vim servers: ${_servers_list}"
    _server_name=$(tmux display-message -p '#S-#W')
    # Convert to upper case
    _server_name=${_server_name:u}
    io::vlog 1 "Vim server name to use: ${_server_name}"
    local _server_exists
    for server in ${_servers_list}; do
      io::vlog 1 "Found vim server: ${server}"
      if [[ "${_server_name}" == "${server}" ]]; then
        _server_exists='yes'
        break
      fi
    done
    if [[ -z "${_server_exists}" ]]; then
      io::vlog 1 "Starting vim with server name: ${_server_name}"
      \vim ${_vimflags} --servername "${_server_name}" "$@"
    else
      io::vlog 1 "Connecting to vim server: ${_server_name}"
      \vim ${_vimflags} --servername ${_server_name} --remote "$@"
    fi
  fi
}

: <<=cut
=item Function C<util::_gvim>

Open files with gvim in a single gvim instance.

@return NULL
=cut
function util::_gvim() {
  local -a _servers_list
  _servers_list=($(\vim --serverlist))
  io::vlog 1 "Vim servers: ${_servers_list}"

  local _server_name
  for server in ${_servers_list}; do
    io::vlog 1 "Found vim server: ${server}"
    if [[ "${server}" =~ '^GVIM.*' ]]; then
      _server_name="${server}"
      break
    fi
  done
  if [[ -z "${_server_name}" ]]; then
    _server_name='GVIM-SINGLETON'
    io::vlog 1 "Starting gVim with server name: ${_server_name}"
    \vim -g --servername "${_server_name}" "$@"
  else
    io::vlog 1 "Connecting to gVim server: ${_server_name}"
    \vim -g --servername ${_server_name} --remote "$@"
  fi
}

: <<=cut
=item Function C<util::_check_test_coverage>

Check test coverage for zsh functions.

@return NULL
=cut
function util::_check_test_coverage() {
  setopt localoptions err_return nounset
  local -a _functions _tests
  local -A _test_cases
  local _ignore
  _ignore=$(cat lib/.ignore)
  io::vlog 1 "Ignored files: ${_ignore}"
  _tests=($(find tests/ -name "*.zsh" | grep -v ${_ignore} | xargs grep -h -o "^function test::.*()" | sed -e 's/^function \(.*\)()/\1/'))
  io::vlog 1 "Tests:\n${_tests}"
  for t in ${_tests}; do
    io::vlog 1 ${t/test::/}
    _test_cases[${t/test::/}]=$t
  done
  io::vlog 2 "Testcases:\n${(kv)_test_cases}"

  _functions=($(find lib/ -name "*.zsh" | grep -v ${_ignore} | xargs grep -h -o "^function .*()" | sed -e 's/^function \(.*\)()/\1/'))
  io::vlog 1 "Functions:\n${_functions}"
  for f in ${_functions}; do
    if [[ "$f" =~ '[^:]*::_.*' ]]; then
      io::vlog 2 "Skipping whitelisted function $f"
    elif [[ ${+_test_cases[${f}]} -eq 0 ]]; then
      io::hl "✗ $f"
    else
      io::msg "✓ $f : ${_test_cases[${f}]}"
    fi
  done
}

function util::_tmux_attach() {
  local setenv=$(mktemp)
  : > "$setenv"
  for var in SSH_OS SSH_CLIENT DISPLAY;
  do
    local value=
    eval value=\$$var
    # local _var_
    # eval "_val_=\"\${$var}\""
    # echo $_val_
    \tmux set-environment $var "$value"
    echo "export $var=\"$value\"" >> "$setenv"
  done
  for window in $(\tmux list-windows -t "$1" -F "#W");
  do
    for pane_id_command in $(\tmux list-panes -t "$1:$window" -F "#P:#{pane_current_command}");
    do
      local id=${pane_id_command%%:*}
      local cmd=${pane_id_command##*:}
      \tmux send-keys -t "$1:$window.$id" C-z
      sleep 0.1
      \tmux send-keys -t "$1:$window.$id" ENTER
      sleep 0.1
      if [[ $cmd != "bash" && $cmd != "zsh" && $cmd != "blaze64" ]]; then
        # run "\\tmux send-keys -t \"$1:$window\" C-z"
        # run "\tmux send-keys -t \"$1:$window.$id\" source \\ $setenv ENTER"
        \tmux send-keys -t "$1:$window.$id" source \ $setenv ENTER
        sleep 0.1
        # run "\\tmux send-keys -t \"$1:$window.$id\" fg ENTER"
        \tmux send-keys -t "$1:$window.$id" fg ENTER
      else
        \tmux send-keys -t "$1:$window.$id" source \ $setenv ENTER
        # run "\\tmux send-keys -t \"$1:$window.$id\" source \\ $setenv ENTER"
      fi
    done
  done
  \tmux attach -d -t "$1"
}

: <<=cut
=back
=cut
