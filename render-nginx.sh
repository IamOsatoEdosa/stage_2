#!/usr/bin/env bash
set -euo pipefail

# Load environment variables from .env
set -a
. ./.env
set +a

# Ensure required vars are set
: "${ACTIVE_POOL:?ACTIVE_POOL must be set (blue|green)}"
: "${APP_INTERNAL_PORT:?APP_INTERNAL_PORT must be set}"

out="nginx/nginx.conf"
mkdir -p nginx

# Generate upstream block depending on ACTIVE_POOL
if [ "$ACTIVE_POOL" = "blue" ]; then
  upstream_block=$(cat <<EOF
    upstream backend {
        server app_blue:${APP_INTERNAL_PORT} max_fails=1 fail_timeout=3s;
        server app_green:${APP_INTERNAL_PORT} backup;
    }
EOF
)
elif [ "$ACTIVE_POOL" = "green" ]; then
  upstream_block=$(cat <<EOF
    upstream backend {
        server app_green:${APP_INTERNAL_PORT} max_fails=1 fail_timeout=3s;
        server app_blue:${APP_INTERNAL_PORT} backup;
    }
EOF
)
else
  echo "ACTIVE_POOL must be 'blue' or 'green'." >&2
  exit 1
fi

# Write final nginx.conf
cat > "$out" <<EOF
worker_processes  1;

events { worker_connections 1024; }

http {
$upstream_block

$(cat nginx/nginx.conf.template)
}
EOF

echo "[INFO] Rendered nginx.conf with ACTIVE_POOL=$ACTIVE_POOL → $out"