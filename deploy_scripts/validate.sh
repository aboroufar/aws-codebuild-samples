#!/bin/bash
set -euo pipefail

# Retry checking localhost:80 for up to 30 seconds
for i in {1..10}; do
  HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:80/ || true)
  if [ "$HTTP_CODE" = "200" ]; then
    echo "Healthcheck passed: HTTP 200"
    exit 0
  fi
  echo "Waiting for app to start (attempt $i/10, status: $HTTP_CODE)..."
  sleep 3
done

echo "Healthcheck failed after 30 seconds" >&2
exit 1