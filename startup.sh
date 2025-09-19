#!/bin/bash
set -e

# Fix locale warnings
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Start VNC server if not already running
if ! pgrep -x Xtigervnc > /dev/null; then
    echo "Starting VNC server..."
    tigervncserver :1 -geometry 1280x800 -depth 24
else
    echo "VNC server already running."
fi

# Start noVNC
echo "Starting noVNC on port 6080..."
/usr/share/novnc/utils/novnc_proxy --vnc localhost:5901 --listen 6080 &
NOVNC_PID=$!

# Check if Chromium is installed
if ! command -v chromium &> /dev/null; then
    echo "Chromium not found. Installing..."

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

# Start Openbox session
echo "Starting Openbox..."
openbox-session &

# Launch Chromium
echo "Launching Chromium..."
chromium --no-sandbox --disable-dev-shm-usage &

# Keep container running
wait $NOVNC_PID
