#!/usr/bin/env bash
set -e

# Setup VNC password
mkdir -p $HOME/.vnc
echo "vncpass" | vncpasswd -f > $HOME/.vnc/passwd
chmod 600 $HOME/.vnc/passwd

# Kill any existing VNC session
vncserver -kill :1 || true
rm -rf /tmp/.X1-lock /tmp/.X11-unix/X1

# Start VNC server first
vncserver :1 -geometry 1280x800 -depth 24

# Export DISPLAY so apps know where to draw
export DISPLAY=:1

# Start Openbox session
openbox-session &

# Launch Chromium + File Manager
chromium-browser --no-sandbox --disable-dev-shm-usage &  
pcmanfm &

# Start noVNC proxy
exec /usr/share/novnc/utils/launch.sh --vnc localhost:5901 --listen 6080
