#!/bin/bash
set -e

# Fix locale warnings
export LANG=C.UTF-8
export LC_ALL=C.UTF-8

echo "Cleaning up old VNC sessions..."
vncserver -kill :1 > /dev/null 2>&1 || true
pkill -f Xtigervnc || true
rm -rf /tmp/.X*-lock /tmp/.X11-unix/X*

echo "Starting VNC server..."
tigervncserver :1 -geometry 1280x800 -depth 24

echo "Starting noVNC..."
/usr/share/novnc/utils/launch.sh --vnc localhost:5901 --listen 6080 &

# Desktop environment (XFCE)
if ! dpkg -l | grep -q xfce4; then
    echo "Installing XFCE4 desktop..."
    apt-get update
    DEBIAN_FRONTEND=noninteractive apt-get install -y xfce4 xfce4-terminal
fi

# Chromium (Ubuntu's ungoogled Chromium build)
if ! command -v chromium &> /dev/null && ! command -v chromium-browser &> /dev/null; then
    echo "Installing Chromium..."
    apt-get update
    apt-get install -y chromium-browser || apt-get install -y chromium
fi

# Create autostart entry to launch Chromium
mkdir -p ~/.config/autostart
cat > ~/.config/autostart/chromium.desktop <<EOF
[Desktop Entry]
Type=Application
Exec=chromium --no-sandbox --disable-dev-shm-usage --start-maximized
Hidden=false
X-GNOME-Autostart-enabled=true
Name=Chromium
EOF

echo "Starting XFCE4 session..."
DISPLAY=:1 startxfce4 &

echo "✅ Startup complete. Open noVNC at port 6080."
tail -f /dev/null
