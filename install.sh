#!/bin/bash
set -e

echo "Updating package lists..."
apt-get update -y

echo "Installing core dependencies..."
apt-get install -y \
    supervisor \
    tigervnc-standalone-server \
    novnc websockify \
    lxde-core lxterminal \
    chromium-browser \
    wget curl xz-utils

echo "Creating supervisord config..."
cat > /workspaces/Chromium-Emulator/supervisord.conf <<EOL
[supervisord]
nodaemon=true
logfile=/tmp/supervisord.log

[program:Xvnc]
command=/usr/bin/vncserver :1 -geometry 1280x800 -depth 24
priority=1
autostart=true
autorestart=true
stdout_logfile=/tmp/vnc.log
stderr_logfile=/tmp/vnc.err

[program:lxde]
command=startlxde
priority=2
autostart=true
autorestart=true
stdout_logfile=/tmp/lxde.log
stderr_logfile=/tmp/lxde.err

[program:noVNC]
command=/usr/bin/websockify --web=/usr/share/novnc/ 6080 localhost:5901
priority=3
autostart=true
autorestart=true
stdout_logfile=/tmp/novnc.log
stderr_logfile=/tmp/novnc.err

[program:chromium]
command=/usr/bin/chromium-browser --no-sandbox --disable-dev-shm-usage --disable-gpu --remote-debugging-port=9222
priority=4
autostart=true
autorestart=true
stdout_logfile=/tmp/chromium.log
stderr_logfile=/tmp/chromium.err
EOL

echo "✅ Install complete!"
