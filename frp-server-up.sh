#!/bin/bash

# --- SETTINGS ---
FRP_VERSION=0.63.0
FRP_PLATFORM=linux_amd64
FRP_DIR="frp_${FRP_VERSION}_${FRP_PLATFORM}"
FRP_DOWNLOAD_URL="https://github.com/fatedier/frp/releases/download/v${FRP_VERSION}/${FRP_DIR}.tar.gz"
FRP_INSTALL_DIR="/opt/frp"
FRPS_BINARY="${FRP_INSTALL_DIR}/frps"

# --- ENSURE INSTALL DIR EXISTS ---
mkdir -p "$FRP_INSTALL_DIR"

# --- DOWNLOAD + INSTALL IF NEEDED ---
if [[ ! -f "$FRPS_BINARY" ]]; then
  echo "📦 Downloading FRP server to $FRP_INSTALL_DIR..."
  wget "$FRP_DOWNLOAD_URL" -O frp.tar.gz || {
    echo "❌ Download failed. Check URL or network."
    exit 1
  }

  tar -xzf frp.tar.gz
  mv "${FRP_DIR}/frps" "$FRPS_BINARY"
  chmod +x "$FRPS_BINARY"
  rm -rf "$FRP_DIR" frp.tar.gz
fi

# --- CREATE CONFIG IF NEEDED ---
cat > "$FRP_INSTALL_DIR/frps.ini" <<EOF
[common]
bind_port = 1000
dashboard_port = 1500
dashboard_user = admin
dashboard_pwd = admin
EOF

# --- START FRP SERVER ---
cd "$FRP_INSTALL_DIR"
export BUILD_ID=dontKillMe
nohup "$FRPS_BINARY" -c frps.ini > frps.log 2>&1 &

echo "✅ FRP server started on port 1000, dashboard at :1500"
