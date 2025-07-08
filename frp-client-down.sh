#!/bin/bash

LOCAL_PORT="$LOCAL_PORT"
REMOTE_PORT="$REMOTE_PORT"
FRPC_DIR="$FRP_DIR/frpc_clients"
PID_FILE="$FRPC_DIR/frpc_${LOCAL_PORT}_${REMOTE_PORT}.pid"

if [ -f "$PID_FILE" ]; then
  PID=$(cat "$PID_FILE")
  echo "Stopping tunnel: local $LOCAL_PORT → remote $REMOTE_PORT (PID: $PID)"
  kill "$PID"
  rm -f "$PID_FILE"
  echo "Tunnel stopped successfully."
else
  echo "No PID file found at $PID_FILE"
  exit 1
fi
