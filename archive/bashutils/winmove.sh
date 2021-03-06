#!/usr/bin/env bash

LOGFILE=/tmp/log.txt

function get_active_win_geometry() {
  local _id_=$(xdotool getactivewindow)
  while read -a a;
  do
    w=${a[0]};
    if (($((16#${w:2}))==_id_)); then
      WIN_X=${a[3]}
      WIN_Y=${a[4]}
      WIN_W=${a[5]}
      WIN_H=${a[6]}
      if [[ $DEBUG == true ]]; then
        echo $WIN_X $WIN_Y $WIN_W $WIN_H >> $LOGFILE
      fi
      break;
    fi;
  done < <(wmctrl -lpG)
}

function log_run() {
  if [[ $DEBUG == true ]]; then
    echo "$1" >> $LOGFILE
  fi
  $1
}

get_active_win_geometry
if [[ $DEBUG == true ]]; then
  echo "Moving to $1" >> $LOGFILE
fi

if [[ $WIN_X -ge 1366 ]]; then
  if [[ $1 == "LEFT" ]]; then
    log_run 'wmctrl -r :ACTIVE: -b remove,maximized_vert,maximized_horz'
    log_run 'wmctrl -r :ACTIVE: -e 0,0,0,1366,670'
  fi
else
  if [[ $1 == "RIGHT" ]]; then
    log_run 'wmctrl -r :ACTIVE: -b remove,maximized_vert,maximized_horz'
    log_run 'wmctrl -r :ACTIVE: -e 0,1366,0,1920,1160'
  fi
fi
log_run 'wmctrl -r :ACTIVE: -b add,maximized_vert,maximized_horz'
