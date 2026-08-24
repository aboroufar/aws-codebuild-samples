#!/bin/bash
export PATH=$PATH:/usr/bin:/usr/local/bin:/usr/sbin:/usr/local/sbin

if command -v pm2 >/dev/null 2>&1; then
  pm2 delete calculator || true
fi

exit 0