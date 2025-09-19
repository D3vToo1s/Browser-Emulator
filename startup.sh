#!/bin/bash
set -e

# Fix locale
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

# Install XFCE4 if missing
if ! command -v startxfce4 &>/dev/null; then
    echo "Installing XFCE4 desktop..."
    DEBIAN_FRONTEND=noninteractive apt-get update
    DEBIAN_FRONTEND=noninteractive apt-get install -y xfce4 xfce4-terminal
fi

# Install Firefox as guaranteed browser
if ! command -v firefox &>/dev/null; then
    echo "Installing Firefox..."
    apt-get update
    apt-get install -y firefox
fi

# Autostart Firefox inside XFCE
mkdir -p ~/.config/autostart
cat > ~/.config/autostart/browser.desktop <<EOF
[Desktop Entry]
Type=Application
Exec=firefox --kiosk https://example.com
Hidden=false
X-GNOME-Autostart-enabled=true
Name=Firefox
EOF

echo "Starting XFCE4 session..."
DISPLAY=:1 startxfce4 &

echo "✅ Desktop is ready! Open your browser at port 6080."
tail -f /dev/null
