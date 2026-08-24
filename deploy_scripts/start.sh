#!/bin/bash
set -euo pipefail
set -x

echo "=== [ApplicationStart] Starting Calculator Service ==="

export PATH=$PATH:/usr/bin:/usr/local/bin:/usr/sbin:/usr/local/sbin

APP_DIR="/home/ec2-user/calculator"
APP_NAME="calculator"
ENTRY_POINT="service.js"

cd "$APP_DIR"

# Clean up any existing PM2 instance
pm2 delete "$APP_NAME" || true

# Start the application on port 80
PORT=80 pm2 start "$ENTRY_POINT" --name "$APP_NAME"
pm2 save

echo "=== [ApplicationStart] Application started on port 80 ==="
exit 0