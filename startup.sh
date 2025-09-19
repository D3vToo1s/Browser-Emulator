#!/usr/bin/env bash
set -e

# Start Openbox session
openbox-session &

# Start VNC server on :1
vncserver :1 -geometry 1280x800 -depth 24

# Launch Chromium and file manager inside VNC session
DISPLAY=:1 chromium-browser --no-sandbox & 
DISPLAY=:1 pcmanfm &

# Start noVNC (websockify on port 6080)
websockify --web=/usr/share/novnc/ 6080 localhost:5901
