#!/bin/bash
set -euo pipefail
set -x

echo "=== [ApplicationStart] Starting Calculator Service ==="

export PATH=$PATH:/usr/bin:/usr/local/bin:/usr/sbin:/usr/local/sbin

APP_DIR="/home/ec2-user/calculator"
APP_NAME="calculator"
ENTRY_POINT="service.js"

cd "$APP_DIR"

# Stop existing instance if any
pm2 delete "$APP_NAME" || true

# Pass 80 as a CLI argument to service.js via PM2
pm2 start "$ENTRY_POINT" --name "$APP_NAME" -- 80
pm2 save

echo "=== [ApplicationStart] Started on port 80 ==="
exit 0