#!/usr/bin/env bash
set -e

# Setup VNC password
mkdir -p $HOME/.vnc
echo "vncpass" | vncpasswd -f > $HOME/.vnc/passwd
chmod 600 $HOME/.vnc/passwd

# Kill any old VNC
vncserver -kill :1 || true
rm -rf /tmp/.X1-lock /tmp/.X11-unix/X1

# Start Openbox session in background
openbox-session &

# Start VNC server
vncserver :1 -geometry 1280x800 -depth 24

# Launch Chromium + File Manager inside DISPLAY :1
export DISPLAY=:1
chromium-browser --no-sandbox --disable-dev-shm-usage &  
pcmanfm &

# Start noVNC
exec /usr/share/novnc/utils/launch.sh --vnc localhost:5901 --listen 6080
