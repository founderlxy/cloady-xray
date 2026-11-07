#!/bin/sh
set -e
# Cloady assigns the container port via $PORT when present; fall back
# to 3000. TLS is terminated by Cloady's edge (443), so xray itself
# serves plain WebSocket here.
PORT="${PORT:-3000}"
UUID="${UUID:?UUID env var is required}"
WS_PATH="${WS_PATH:-/tk-rail}"
cat > /tmp/config.json <<EOF
{
  "log": {"loglevel": "warning"},
  "inbounds": [
    {
      "port": $PORT,
      "listen": "0.0.0.0",
      "protocol": "vless",
      "settings": {
        "clients": [{"id": "$UUID", "level": 0}],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "ws",
        "wsSettings": {"path": "$WS_PATH"}
      }
    }
  ],
  "outbounds": [{"protocol": "freedom", "tag": "direct"}]
}
EOF
exec /usr/local/bin/xray run -c /tmp/config.json
