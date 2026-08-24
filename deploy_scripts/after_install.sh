#!/bin/bash
set -euo pipefail

cd /home/ec2-user/calculator

# Install production dependencies if package.json exists
if [ -f "package.json" ]; then
  npm install --production
fi