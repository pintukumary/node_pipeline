#!/bin/bash
set -e
set -x

echo "---- STARTING start_server.sh ----"

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

export NVM_DIR="/root/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

nvm install v22
nvm use v22

export HOME=/root
export PATH="/root/.nvm/versions/node/v22.21.1/bin:$PATH"

echo "Node.js version: $(node --version)"
npm install -g pm2 yarn

cd /var/www/html
echo "Node version checking"
node --version
npm install

if pm2 list | grep -q "arken-frontend-dev"; then
    echo "🔁 PM2 process 'arken-frontend-dev' found — restarting..."
    pm2 restart arken-frontend-dev || { echo "❌ PM2 restart failed"; exit 1; }
else
    echo "🚀 PM2 process 'arken-frontend-dev' not found — starting new process..."
    pm2 start npm --name "arken-frontend-dev" -- run dev -- -H 0.0.0.0 -p 3000 || {
        echo "❌ PM2 start failed. Here is the PM2 list for debugging:"
        pm2 list
        exit 1
    }
fi


echo "Hello this is start_server.sh file"
