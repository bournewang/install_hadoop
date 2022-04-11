#!/bin/sh
run_show_cmd(){
  cmd=$1
  to=$2
  if [ ! $to ]; then
    echo "\t$cmd"
    $cmd
  else
    echo "\t$cmd >> $to"
    $cmd >> $to
  fi
}


run_show_cmd "echo hello "
run_show_cmd "echo hello to log " log