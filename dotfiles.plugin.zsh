# vim: ft=zsh sw=2 ts=2 sts=2 et tw=80 fdl=0 fdm=marker nospell

[[ -d ~/.local/bin ]] || mkdir -p ~/.local/bin

local current_wd=${0:A:h}/zsh/plugin
fpath+=(${current_wd}/functions)
autoload -Uz -- ${current_wd}/functions/[^_]*(:t)
manpath+=(${current_wd}/man)

# The time the shell waits, in hundredths of seconds, for another key to be
# pressed when reading bound multi-character sequences.
# declare -xg KEYTIMEOUT=10
declare -xg EDITOR=vim VISUAL=vim
# zle_bracketed_paste

zstyle ":registry:var:prefix-width" registry 10
for f in $(ls ${current_wd}/enabled/*.zsh); do
  source $f
done
