#!/bin/bash
pidfile="/tmp/waybar-stats.pid"

if [ -f "$pidfile" ] && kill -0 "$(cat "$pidfile")" 2>/dev/null; then
  kill "$(cat "$pidfile")"
  rm "$pidfile"
else
  nohup waybar -c ~/.config/waybar/stats_config.jsonc > /dev/null 2>&1 &
  echo $! > "$pidfile"
fi
