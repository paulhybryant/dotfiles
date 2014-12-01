# Configs local to workstation.
source /etc/bash_completion.d/g4d

zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zshcache

P4DIFF="/google/src/files/head/depot/google3/devtools/scripts/p4diff -b"
export PATH=~/bin:$PATH

# effingo
function eq() {
  effingo --user=moneta-datawarehouse-qa-prod "$@"
}
function ep() {
  effingo --user=moneta-datawarehouse "$@"
}
function ecn() {
  effingo --user=cds-users-nonprod "$@"
}
function ecu() {
  effingo --user=cds-users "$@"
}
function egu() {
  effingo --user=gdw-revenue-uat --group=cds-users-nonprod "$@"
}
function egp() {
  effingo --user=gdw-revenue-prod --group=cds-users "$@"
}


# borgcfg
function bq() {
  borgcfg --borguser=moneta-datawarehouse-qa-prod "$@"
}
function bp() {
  borgcfg --borguser=moneta-datawarehouse "$@"
}
function bae() {
  borgcfg --borguser=adsdw-etl "$@"
}
function bat() {
  borgcfg --borguser=adsdw-test "$@"
}
function bpvc() {
  borgcfg --borguser=pipelines-pvc "$@"
}
function bgt() {
  borgcfg --borguser=gdw-revenue-test --user=gdw-revenue-test "$@"
}
function bgu() {
  borgcfg --borguser=gdw-revenue-uat --user=gdw-revenue-uat "$@"
}
function bgp() {
  borgcfg --borguser=gdw-revenue-prod --user=gdw-revenue-prod "$@"
}


# tenzing
function tzvc() {
  /usr/lib/tsl_client/tsl_client_tier3_binary --tenzing_stubby_server=/bns/vc/borg/vc/bns/tenzing/tenzing-default.stubby/0 --tsl_client_prompt='tzvc> ' "$@"
}
function tzic() {
  /usr/lib/tsl_client/tsl_client_tier3_binary --tenzing_stubby_server=/bns/ic/borg/ic/bns/tenzing/tenzing-default.stubby/0 --tsl_client_prompt='tzic> ' "$@"
}
function tzie() {
  /usr/lib/tsl_client/tsl_client_tier3_binary --tenzing_stubby_server=/bns/ie/borg/ie/bns/tenzing/tenzing-default.stubby/0 --tsl_client_prompt='tzie> ' "$@"
}
function tzia() {
  /usr/lib/tsl_client/tsl_client_tier3_binary --tenzing_stubby_server=/bns/ia/borg/ia/bns/tenzing/tenzing-default.stubby/0 --tsl_client_prompt='tzia> ' "$@"
}
function tzih() {
  /usr/lib/tsl_client/tsl_client_tier3_binary --tenzing_stubby_server=/bns/ih/borg/ih/bns/tenzing/tenzing-default.stubby/0 --tsl_client_prompt='tzih> ' "$@"
}
function tzob() {
  /usr/lib/tsl_client/tsl_client_tier3_binary --tenzing_stubby_server=/bns/ob/borg/ob/bns/tenzing/tenzing-default.stubby/0 --tsl_client_prompt='tzob> ' "$@"
}


# fileutil aliases
function f() {
  fileutil "$@"
}
function fq() {
  if [ "$1" = "snapshot" ];
  then
    fileutil --gfs_user=moneta-datawarehouse-qa-prod -g=moneta-datawarehouse-qa-prod "$@" 0027 0137
  else
    fileutil --gfs_user=moneta-datawarehouse-qa-prod -g=moneta-datawarehouse-qa-prod "$@"
  fi
}
function fp() {
  if [ "$1" = "snapshot" ];
  then
    fileutil --gfs_user=moneta-datawarehouse -g=moneta-datawarehouse "$@" 0027 0137
  else
    fileutil --gfs_user=moneta-datawarehouse -g=moneta-datawarehouse "$@"
  fi
}
function fgt() {
  if [ "$1" = "snapshot" ];
  then
    fileutil --gfs_user=gdw-revenue-test -g=cds-users-nonprod "$@" 0027 0137
  else
    fileutil --gfs_user=gdw-revenue-test -g=cds-users-nonprod "$@"
  fi
}
function fgu() {
  if [ "$1" = "snapshot" ];
  then
    fileutil --gfs_user=gdw-revenue-uat -g=cds-users-nonprod "$@" 0027 0137
  else
    fileutil --gfs_user=gdw-revenue-uat -g=cds-users-nonprod "$@"
  fi
}
function fgp() {
  if [ "$1" = "snapshot" ];
  then
    fileutil --gfs_user=gdw-revenue-prod -g=cds-users "$@" 0027 0137
  else
    fileutil --gfs_user=gdw-revenue-prod -g=cds-users "$@"
  fi
}
function fcu() {
  if [ "$1" = "snapshot" ];
  then
    fileutil --gfs_user=cds-users -g=cds-users "$@" 0027 0137
  else
    fileutil --gfs_user=cds-users -g=cds-users "$@"
  fi
}
function fcn() {
  if [ "$1" = "snapshot" ];
  then
    fileutil --gfs_user=cds-users-nonprod -g=cds-users-nonprod "$@" 0027 0137
  else
    fileutil --gfs_user=cds-users-nonprod -g=cds-users-nonprod "$@"
  fi
}
function ftz() {
  if [ "$1" = "snapshot" ];
  then
    fileutil --gfs_user=tenzing -g=tenzing "$@" 0027 0137
  else
    fileutil --gfs_user=tenzing -g=tenzing "$@"
  fi
}
function fle() {
  fileutil ls -le -h -sharded $* | awk -f $HOME/.utils/flldu.awk
}
function fll() {
  fileutil ls -l -h -F -sharded $* | awk -f $HOME/.utils/flldu.awk
}
function fla() {
  fileutil ls -le -h -a -sharded $* | awk -f $HOME/.utils/flldu.awk
}
function fldu() {
  fileutil ls -l | awk -f $HOME/.utils/lsdu.awk
}
function ftf() {
  fileutil translatefully $*
}

export x20=/google/data/rw/users/yu/yuhuang

# misc
alias pa="prodaccess -g"
alias pao="prodaccess"
alias gvim="$HOME/.gvim.sh"
alias rm="rm -v"
alias g5='/google/data/ro/projects/shelltoys/g5.sar'
alias mysql='/google/data/ro/projects/production/mysql/python/sql.par'
alias gtags="/home/build/nonconf/google3/tools/tags/gtags.sh"
alias mt="/google/data/ro/projects/monarch/monarch_tool"
alias pp="/google/data/ro/projects/patchpanel/patchpanel"
alias mash="/google/data/ro/projects/monarch/mash"
alias sync_dir="/google/data/ro/projects/sre_cil/sync_dir"
g3() {
  cd "${PWD%${PWD##*/google3}}/"
}

function g5repatch() {
  if [ $# -ne 1 ]
  then
    echo "Usage: g5repatch #CL."
    return
  fi

  if [[ ! $PWD =~ .*google3$ ]]
  then
    echo "Must be run with google3 as the CWD."
    return
  fi

  g4 list -s $1 | sed -s 's@//depot/google3/@@' | xargs -n 1 git5 revert
  git5 patch -c $1
}

# blaze
# Build mode controlled by ~/.blazerc
# By default it is fastbuild mode
alias bb='blaze build'
alias bbo='blaze build -c opt'
alias bbd='blaze build -c dbg'
alias bts='blaze test'
alias bto='blaze test -c opt'
alias btd='blaze test -c dbg'
alias btol='blaze test -c opt --test_strategy=local'
alias btl='blaze test --test_strategy=local'
alias fixdeps="/google/src/files/head/depot/devtools/blazeutils/fixdeps_main.par"
alias iwyu="/google/src/head/depot/google3/devtools/maintenance/include_what_you_use/iwyu.py --checkout_command='g4 edit'"
alias iwyu2="/google/src/head/depot/google3/devtools/maintenance/include_what_you_use/iwyu.py --checkout_command='g4 edit' --nosafe_headers"

function cbb() {
  if [[ -n "${PWD/*\/google3\/blaze-bin*}" ]]; then
    cd "${PWD/\/google3//google3/blaze-bin}" > /dev/null
  else
    cd "${PWD/\/google3\/blaze-bin//google3}" > /dev/null
  fi
}
function cbg() {
  if [[ -n "${PWD/*\/google3\/blaze-genfiles*}" ]]; then
    cd "${PWD/\/google3//google3/blaze-genfiles}" > /dev/null
  else
    cd "${PWD/\/google3\/blaze-genfiles//google3}" > /dev/null
  fi
}

function cg() {
  if [ $# -ne 1 ]
  then
    echo "Usage: cg [branch]."
    return
  fi
  cd ~/git5/$1/google3
}

function checkdeps() {
  blaze analyze --static_analysis=checkdeps "$@"
}

# Setup gnubby forwarding
nc -z localhost 1817
if [ $? -eq 0 ]
then
  echo -ne "yuhuang-glaptop 3000:\r\n\r\n" | nc localhost 1817
fi
