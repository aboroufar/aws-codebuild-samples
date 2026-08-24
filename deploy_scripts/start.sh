#!/bin/bash
set -euo pipefail

APP_DIR="/home/ec2-user/calculator"
APP_NAME="calculator"
ENTRY_POINT="service.js"

cd "$APP_DIR"

# Restart or start fresh on default port 8080
pm2 delete "$APP_NAME" || true
pm2 start "$ENTRY_POINT" --name "$APP_NAME"
pm2 save

exit 0