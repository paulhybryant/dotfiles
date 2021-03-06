#!/usr/bin/env zsh

local _dir=${0:h}/../../functions/
fpath+=(${_dir})
autoload -Uz zsh::autoload time::getmtime io::err
zsh::autoload -d ${_dir} ${_dir}/[^_]*(:t)

set -x

function test::zsh::autoload() {
  local _expected
  _expected=$(time::getmtime ${_dir}/zsh::autoload)
  zstyle -s ":registry:fn:zsh::autoload" registry "_actual"
  [[ "${_expected}" == "${_actual}" ]]

  touch ${_dir}/zsh::autoload
  zsh::autoload -d ${_dir} zsh::autoload
  _expected=$(time::getmtime ${_dir}/zsh::autoload)
  zstyle -s ":registry:fn:zsh::autoload" registry "_actual"
  [[ "${_expected}" == "${_actual}" ]]

  touch ${_dir}/zsh::autoload
  zsh::autoload -a -d ${_dir}
  _expected=$(time::getmtime ${_dir}/zsh::autoload)
  zstyle -s ":registry:fn:zsh::autoload" registry "_actual"
  [[ "${_expected}" == "${_actual}" ]]
}
test::zsh::autoload
