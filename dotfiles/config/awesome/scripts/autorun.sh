#!/usr/bin/env bash

function run {
  if ! pgrep -f $1 ;
  then
    $@&
  fi
}

run picom
run sudo nm-applet
run spotify-launcher
run discord
run steam
