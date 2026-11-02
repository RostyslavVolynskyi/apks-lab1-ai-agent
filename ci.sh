#!/usr/bin/env bash
set -e

if [ -f package-lock.json ]; then
  npm ci
else
  npm install
fi

npm run build
npm test
npm start
