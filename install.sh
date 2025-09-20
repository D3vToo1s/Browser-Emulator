#!/bin/bash
set -e

echo "=== Cleaning up old repos and packages ==="
sudo rm -f /etc/apt/sources.list.d/*.list
sudo apt-get update
sudo apt-get remove -y chromium-browser || true

echo "=== Installing dependencies ==="
sudo apt-get update
sudo apt-get install -y wget curl gnupg2 \
    tigervnc-standalone-server novnc websockify \
    lxde pcmanfm supervisor

echo "=== Installing Chromium 98 (deb package) ==="
CHROMIUM_DEB="chromium-browser_98.0.4758.102-0ubuntu0.20.04.1_amd64.deb"
wget -q https://launchpad.net/ubuntu/+archive/primary/+files/$CHROMIUM_DEB -O /tmp/chromium.deb
sudo apt-get install -y /tmp/chromium.deb || true

echo "=== Setting Chromium to autostart on LXDE ==="
mkdir -p ~/.config/lxsession/LXDE/
cat > ~/.config/lxsession/LXDE/autostart <<EOF
@chromium-browser --no-sandbox --disable-gpu --disable-software-rasterizer --start-maximized
EOF

echo "=== Creating supervisord config ==="
cat > ~/supervisord.conf <<EOF
[supervisord]
nodaemon=true

[program:vnc]
command=/usr/bin/vncserver :1 -geometry 1280x800 -depth 24
autostart=true
autorestart=true

[program:lxde]
command=startlxde
autostart=true
autorestart=true

[program:novnc]
command=/usr/share/novnc/utils/novnc_proxy --vnc localhost:5901 --listen 6080
autostart=true
autorestart=true
EOF

echo "=== Installation complete ==="
echo "Run ./startup.sh to launch environment."
