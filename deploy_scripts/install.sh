#!/bin/bash
set -euo pipefail

# 1. Clean up legacy NVM residues if any exist
rm -rf /root/.nvm /home/ec2-user/.nvm /usr/local/bin/node /usr/local/bin/npm

# 2. Install Node.js & NPM system-wide
if ! command -v node >/dev/null 2>&1; then
  if command -v dnf >/dev/null 2>&1; then
    dnf install -y nodejs npm
  else
    curl -fsSL https://rpm.nodesource.com/setup_20.x | bash -
    yum install -y nodejs
  fi
fi

# 3. Install PM2 globally
if ! command -v pm2 >/dev/null 2>&1; then
  npm install -g pm2
fi

# 4. Prepare project folder
mkdir -p /home/ec2-user/calculator
chown -R ec2-user:ec2-user /home/ec2-user/calculator