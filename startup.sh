#!/bin/bash
set -e

# Fix locale warnings
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

echo "Cleaning up old VNC sessions..."
vncserver -kill :1 > /dev/null 2>&1 || true
pkill -f Xtigervnc || true
rm -rf /tmp/.X*-lock /tmp/.X11-unix/X*

echo "Starting VNC server..."
tigervncserver :1 -geometry 1280x800 -depth 24

echo "Starting noVNC..."
/usr/share/novnc/utils/launch.sh --vnc localhost:5901 --listen 6080 &

# Ensure Chromium exists
if ! command -v chromium &> /dev/null; then
    echo "Installing Chromium (Debian build)..."
    apt-get update
    apt-get install -y wget libnss3 libxss1 libasound2 libatk1.0-0 libatk-bridge2.0-0 \
                       libcups2 libdrm2 libxkbcommon0 libgtk-3-0 libgbm1 libxdamage1 \
                       libxfixes3 libxcomposite1 libxrandr2 fonts-liberation

    cd /tmp
    wget -q http://ftp.us.debian.org/debian/pool/main/c/chromium/chromium_116.0.5845.96-1_amd64.deb
    wget -q http://ftp.us.debian.org/debian/pool/main/c/chromium/chromium-common_116.0.5845.96-1_amd64.deb
    wget -q http://ftp.us.debian.org/debian/pool/main/c/chromium/chromium-sandbox_116.0.5845.96-1_amd64.deb

    dpkg -i chromium*.deb || apt-get -f install -y
    rm -f chromium*.deb
fi

echo "Starting Openbox..."
DISPLAY=:1 openbox-session &

echo "Launching Chromium..."
DISPLAY=:1 chromium --no-sandbox --disable-dev-shm-usage --start-maximized &

echo "Starting File Manager..."
DISPLAY=:1 pcmanfm &

tail -f /dev/null
