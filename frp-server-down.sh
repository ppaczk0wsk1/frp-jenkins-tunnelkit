#!/bin/bash
FRP_PID=$(pgrep -f frps)

if [ -n "$FRP_PID" ]; then
  echo "Killing frps with PID $FRP_PID"
  kill "$FRP_PID"
else
  echo "No frps process found"
fi
