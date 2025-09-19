#!/bin/bash
set -e

# Fix locale warnings
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

echo "Cleaning up old VNC sessions..."
vncserver -kill :1 > /dev/null 2>&1 || true
pkill -f Xtigervnc || true
rm -rf /tmp/.X*-lock /tmp/.X11-unix/X*

echo "Starting VNC server..."
tigervncserver :1 -geometry 1280x800 -depth 24

echo "Starting noVNC..."
/usr/share/novnc/utils/launch.sh --vnc localhost:5901 --listen 6080 &

# Remove snap chromium wrapper (conflicts in Codespaces)
apt-get remove -y chromium-browser || true

# Ensure Chromium exists
if ! command -v chromium &> /dev/null; then
    echo "Installing Chromium (Debian build)..."
    apt-get update
    apt-get install -y wget libnss3 libxss1 libasound2 libatk1.0-0 libatk-bridge2.0-0 \
                       libcups2 libdrm2 libxkbcommon0 libgtk-3-0 libgbm1 libxdamage1 \
                       libxfixes3 libxcomposite1 libxrandr2 fonts-liberation

    cd /tmp
    wget -q http://ftp.us.debian.org/debian/pool/main/c/chromium/chromium_116.0.5845.96-1_amd64.deb
    wget -q http://ftp.us.debian.org/debian/pool/main/c/chromium/chromium-common_116.0.5845.96-1_amd64.deb
    wget -q http://ftp.us.debian.org/debian/pool/main/c/chromium/chromium-sandbox_116.0.5845.96-1_amd64.deb

    dpkg -i chromium*.deb || apt-get -f install -y
    rm -f chromium*.deb
fi

echo "Starting desktop session..."
cat > ~/.xinitrc <<EOF
#!/bin/bash
openbox-session &
pcmanfm --desktop &
chromium --no-sandbox --disable-dev-shm-usage --start-maximized &
EOF
chmod +x ~/.xinitrc

DISPLAY=:1 startxfce4 2>/dev/null || DISPLAY=:1 ~/.xinitrc &

echo "✅ Startup complete. Connect via port 6080."
tail -f /dev/null
