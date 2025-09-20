#!/bin/bash
set -e

echo "Cleaning up old VNC sessions..."
vncserver -kill :1 > /dev/null 2>&1 || true
rm -rf /tmp/.X1-lock /tmp/.X11-unix/X1

echo "Starting environment with supervisord..."
supervisord -c /workspaces/Chromium-Emulator/supervisord.conf

echo ""
echo "🌍 Access your Chromium desktop here:"
echo "👉 http://127.0.0.1:6080/vnc.html"
echo ""
