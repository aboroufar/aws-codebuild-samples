#!/bin/bash
set -euo pipefail

cd /home/ec2-user/calculator

APP_NAME="calculator"
ENTRY_POINT="app.js"

# Start or reload via PM2 on port 80
if pm2 describe "$APP_NAME" > /dev/null 2>&1; then
  PORT=80 pm2 restart "$APP_NAME" --update-env
else
  PORT=80 pm2 start "$ENTRY_POINT" --name "$APP_NAME"
fi

pm2 save