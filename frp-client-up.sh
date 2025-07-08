#!/bin/bash

if [[ -z "$LOCAL_PORT" || -z "$REMOTE_PORT" ]]; then
  echo "❌ Missing required parameters."
  echo "Please provide: LOCAL_PORT, REMOTE_PORT"
  exit 1
fi

FRP_SERVER=<VPS IP>
FRP_SERVER_PORT=1000
FRP_VERSION=0.63.0
FRP_PLATFORM=linux_amd64
FRP_DIR="frp_${FRP_VERSION}_${FRP_PLATFORM}"

WORKDIR="$WORKSPACE/frpc_clients"
mkdir -p "$WORKDIR"

FRPC_BINARY="$WORKDIR/frpc"
FRPC_CONFIG="$WORKDIR/frpc_${LOCAL_PORT}_${REMOTE_PORT}.ini"
FRPC_LOG="$WORKDIR/frpc_${LOCAL_PORT}_${REMOTE_PORT}.log"
FRPC_PID="$WORKDIR/frpc_${LOCAL_PORT}_${REMOTE_PORT}.pid"

# Download frpc if missing
if [[ ! -f "$FRPC_BINARY" ]]; then
  echo "🔽 Downloading frpc v${FRP_VERSION}..."
  wget "https://github.com/fatedier/frp/releases/download/v${FRP_VERSION}/${FRP_DIR}.tar.gz" -O /tmp/frp.tar.gz || {
    echo "❌ Download failed. Please check FRP version or network."
    exit 1
  }

  tar -xzf /tmp/frp.tar.gz -C /tmp
  mv /tmp/${FRP_DIR}/frpc "$FRPC_BINARY"
  chmod +x "$FRPC_BINARY"
  rm -rf /tmp/${FRP_DIR} /tmp/frp.tar.gz
fi

echo "⚙️ Writing frpc config for local:$LOCAL_PORT → remote:$REMOTE_PORT"
cat > "$FRPC_CONFIG" <<EOL
[common]
server_addr = $FRP_SERVER
server_port = $FRP_SERVER_PORT

[tunnel_${LOCAL_PORT}]
type = tcp
local_port = $LOCAL_PORT
remote_port = $REMOTE_PORT
EOL

# Check if already running
if [[ -f "$FRPC_PID" ]]; then
  PID=$(cat "$FRPC_PID")
  if kill -0 "$PID" >/dev/null 2>&1; then
    echo "⚠️ Tunnel already running with PID $PID"
    exit 0
  else
    echo "⚠️ Stale PID file found, removing"
    rm -f "$FRPC_PID"
  fi
fi

echo "🚀 Starting FRP tunnel..."
export BUILD_ID=dontKillMe
nohup "$FRPC_BINARY" -c "$FRPC_CONFIG" > "$FRPC_LOG" 2>&1 &
echo $! > "$FRPC_PID"

echo "✅ Tunnel running at $FRP_SERVER:$REMOTE_PORT (PID $(cat $FRPC_PID))"
