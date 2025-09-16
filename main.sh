#!/bin/bash
echo "Starting Chromium..."

# Try different Chromium commands
if command -v google-chrome &> /dev/null; then
    echo "Using Google Chrome"
    google-chrome --no-sandbox --disable-gpu --disable-dev-shm-usage --disable-software-rasterizer --disable-extensions --disable-plugins
elif [ -f /opt/chromium/chrome ]; then
    echo "Using downloaded Chromium"
    /opt/chromium/chrome --no-sandbox --disable-gpu --disable-dev-shm-usage --disable-software-rasterizer --disable-extensions --disable-plugins
else
    echo "Installing Google Chrome as Chromium alternative..."
    wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
    echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | sudo tee /etc/apt/sources.list.d/google-chrome.list
    sudo apt update
    sudo apt install -y google-chrome-stable
    google-chrome-stable --no-sandbox --disable-gpu --disable-dev-shm-usage --disable-software-rasterizer --disable-extensions --disable-plugins
fi