#!/usr/bin/env bash

daemon(){
  if [ $# == 0 ]; then
    echo "daemon: make some comman or function to daemon"
    echo "    eg: daemon command log-file"
    exit 1
  fi

  local command="$1"
  shift
  local logfile="${1:-/dev/null}"
  trap "" HUP
  exec &>>"$logfile"
  eval $command &
}
