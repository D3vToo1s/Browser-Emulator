#!/bin/bash
echo "Setting up GUI environment for GitHub Codespaces..."

# Install dependencies
sudo apt update
sudo apt install -y xvfb x11vnc fluxbox websockify novnc

# Install Chromium directly (snap doesn't work in Codespaces)
echo "Installing Chromium browser with language and codec support..."
sudo apt install -y chromium-browser-l10n chromium-codecs-ffmpeg

# Start virtual display
echo "Starting virtual display..."
Xvfb :1 -screen 0 1024x768x24 &
export DISPLAY=:1
fluxbox &

# Start VNC server  
echo "Starting VNC server..."
x11vnc -display :1 -nopw -forever -shared -rfbport 5900 &

# Start noVNC
echo "Starting noVNC web interface on port 6080..."
websockify --web=/usr/share/novnc 6080 localhost:5900 &

echo "Setup complete!"
echo "1. Go to Ports tab in Codespaces"
echo "2. Make port 6080 Public"
echo "3. Click the port link to access desktop"
echo "4. Then run: ./main.sh"