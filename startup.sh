#!/bin/bash
set -e

# Fix locale warnings
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

echo "Cleaning up old VNC sessions..."
vncserver -kill :1 > /dev/null 2>&1 || true
pkill -f Xtigervnc || true
rm -rf /tmp/.X*-lock /tmp/.X11-unix/X*

# Start fresh VNC server
echo "Starting VNC server..."
tigervncserver :1 -geometry 1280x800 -depth 24

# Start noVNC
echo "Starting noVNC on port 6080..."
/usr/share/novnc/utils/launch.sh --vnc localhost:5901 --listen 6080 &

# Start Openbox
echo "Starting Openbox..."
DISPLAY=:1 openbox-session &

# Launch Chromium
echo "Launching Chromium..."
DISPLAY=:1 chromium --no-sandbox --disable-dev-shm-usage --start-fullscreen &

# Launch File Manager
echo "Starting File Manager..."
DISPLAY=:1 pcmanfm &

# Keep container alive
tail -f /dev/null
