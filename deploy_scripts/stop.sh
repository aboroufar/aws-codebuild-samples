#!/bin/bash
# Blue/Green replacement instances won't have a running app on first boot.
# Always exit 0 so the initial deployment hook doesn't abort.

if command -v pm2 >/dev/null 2>&1; then
  pm2 delete calculator || true
fi

exit 0