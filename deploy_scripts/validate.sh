#!/bin/bash
set -euo pipefail

echo "=== [ValidateService] Verifying localhost:80 ==="

for i in {1..10}; do
  HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:80/ || true)
  if [ "$HTTP_STATUS" = "200" ]; then
    echo "Health check passed with HTTP 200"
    exit 0
  fi
  echo "Attempt $i: Received HTTP $HTTP_STATUS, waiting 3s..."
  sleep 3
done

echo "Health check failed after 30 seconds" >&2
exit 1