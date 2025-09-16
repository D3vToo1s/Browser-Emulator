#!/bin/bash
echo "Starting Chrome/Chromium..."

# Try Chrome first, fallback to Chromium
if command -v google-chrome-stable &> /dev/null; then
    echo "Using Google Chrome"
    google-chrome-stable --no-sandbox --disable-gpu --disable-dev-shm-usage --disable-software-rasterizer --disable-extensions --disable-plugins
elif command -v chromium-browser &> /dev/null; then
    echo "Using Chromium"
    chromium-browser --no-sandbox --disable-gpu --disable-dev-shm-usage --disable-software-rasterizer --disable-extensions --disable-plugins
else
    echo "Neither Chrome nor Chromium found."
    echo "Please install one first:"
    echo "  For Chrome: wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add - && sudo sh -c 'echo \"deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main\" >> /etc/apt/sources.list.d/google-chrome.list' && sudo apt update && sudo apt install -y google-chrome-stable"
    echo "  For Chromium: sudo snap install chromium"
fi