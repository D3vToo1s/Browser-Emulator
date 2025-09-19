#!/bin/bash
# Kill any old sessions
vncserver -kill :1 || true

# Setup minimal X session with Openbox WM
mkdir -p ~/.vnc
echo "#!/bin/bash
xrdb $HOME/.Xresources
openbox-session &
chromium-browser --no-sandbox --disable-dev-shm-usage &
pcmanfm &
" > ~/.vnc/xstartup
chmod +x ~/.vnc/xstartup

# Start VNC server
vncserver :1 -geometry 1280x720 -depth 24

# Expose VNC over WebSockets via noVNC
websockify --web=/usr/share/novnc 0.0.0.0:6080 localhost:5901
